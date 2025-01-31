import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/loggy_service.dart';

/*post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
    '$(inherited)',
    'PERMISSION_CAMERA=1',
    'PERMISSION_LOCATION=1',
    ]
    end
  end
end
*/

List<CameraDescription> cameras = [];

class CameraControllerWrapper {
  CameraControllerWrapper() {
    reassignCameraController();
    reassignController = reassignCameraController;
    disposeController = () {
      myLog.traceLog('Camera Disposed');
      isDisposed = true;
      return cameraController?.dispose() ?? Future(() {});
    };
    setCameraStream = (v) {
      stopStream = !v;
    };
  }

  reassignCameraController() {
    isDisposed = false;
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras[1],
        ResolutionPreset.high,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
        enableAudio: false,
      );
    } else {
      throw 'No cameras found!';
    }
  }

  CameraController? cameraController;
  bool isDisposed = false;
  late Future<XFile?> Function() captureImageFunction;
  late Future<void> Function() disposeController;
  late Future<void> Function() switchFlash;
  late Function(bool) setCameraStream;
  bool stopStream = false;
  late Function() reassignController;
}

///camera component will handle dealing with, complete camera initialization.
///and return a camera preview, which will take as much height and width
///as provided, by its parent container widget
class CameraComponent extends StatefulWidget {
  CameraComponent({
    super.key,
    required this.controllerWrapper,
    required this.onCameraInitialized,
    this.imageStream,
  });

  final void Function() onCameraInitialized;
  CameraControllerWrapper controllerWrapper;
  Function(CameraImage)? imageStream;

  @override
  State<CameraComponent> createState() => _CameraComponentState();
}

class _CameraComponentState extends State<CameraComponent>
    with WidgetsBindingObserver {
  bool isInitializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controllerWrapper.captureImageFunction = captureImage;
    widget.controllerWrapper.switchFlash = switchFlash;
    // widget.controllerWrapper.setCameraStream = setCameraStream;

    Future.delayed(Duration.zero, () {
      initializeCameraController();
    });
  }

  Future<void> switchFlash() async {
    FlashMode flashMode =
        widget.controllerWrapper.cameraController!.value.flashMode;
    bool isFlashOff = flashMode == FlashMode.auto;
    if (isFlashOff) {
      await widget.controllerWrapper.cameraController
          ?.setFlashMode(FlashMode.torch);
    } else {
      await widget.controllerWrapper.cameraController
          ?.setFlashMode(FlashMode.auto);
    }
  }

  Future<XFile?> captureImage() async {
    Loggy().infoLog("Captured Image", topic: "CameraPage");
    if (!widget.controllerWrapper.cameraController!.value.isInitialized) {
      return null;
    }
    try {
      XFile file =
      await widget.controllerWrapper.cameraController!.takePicture();
      return file;
    } catch (e, stacktrace) {
      Loggy().errorLog(
        "Unable to capture image :: $e $stacktrace",stacktrace
      );
      return null;
    }
  }

  initializeCameraController() {
    if (widget.controllerWrapper.cameraController!.value.isInitialized) return;
    if (mounted) {
      setState(() {
        isInitializing = true;
      });
    }
    widget.controllerWrapper.cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isPermissionDenied = false;
        isInitializing = false;
      });
      widget.controllerWrapper.cameraController
          ?.lockCaptureOrientation(DeviceOrientation.portraitUp);
      // startingImageStream();
      widget.onCameraInitialized();
    }).catchError(
          (Object e) {
        if (mounted) {
          setState(() {
            isInitializing = false;
          });
        }
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              isPermissionDenied = true;
              // showPermissionDialog();
              break;
          }
        }
      },
    );
  }

  void startingImageStream() {
    if (widget.imageStream == null) return;
    Future.delayed(
      Duration(milliseconds: 500),
          () {
        myLog.traceLog('Camera Stream Started');
        widget.controllerWrapper.cameraController
            ?.startImageStream((cameraImage) async {
          if (!widget.controllerWrapper.stopStream) {
            // myLog.traceLog('Camera Stream Data Sent');
            widget.imageStream!(cameraImage);
          }
        });
      },
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // App state changed before we got the chance to initialize.
    Loggy().traceLog("didChangeAppLifecycleState $state");
    if (!widget.controllerWrapper.cameraController!.value.isInitialized &&
        (await Permission.camera.isDenied)) {
      return;
    }
    Loggy().traceLog("didChangeAppLifecycleState1 $state");
    if (state == AppLifecycleState.inactive) {
      widget.controllerWrapper.disposeController();
    } else if (state == AppLifecycleState.resumed) {
      Loggy().traceLog(
          'controllerWrapper => ${widget.controllerWrapper.isDisposed}');
      if (await Permission.camera.isGranted) {
        widget.controllerWrapper.reassignController();
        initializeCameraController();
      }
    }
  }

  bool isPermissionDenied = false;

/*
  showPermissionDialog() {
    ShowDialog().showVerticalButtonsDialog(
      context,
      title: "Camera Access Denied",
      body: "Camera access is required in order to capture images.",
      buttons: [
        DialogButton(
            buttonText: "Open Settings",
            onTap: () {
              openAppSettings();
              RouteService().pop();
            })
      ],
    );
  }
*/

  @override
  void dispose() {
    widget.controllerWrapper.cameraController?.stopImageStream();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  cameraWidget() {
    return ClipRect(
      child: LayoutBuilder(builder: (_, constraints) {
        double aspectRatio = widget.controllerWrapper.cameraController!.value
            .aspectRatio; // Get camera preview height
        //Please note:- this logic is only compatible in parent widget whose 'width' is more than 'height'.
        late Size size;
        size = Size(constraints.maxWidth, constraints.maxHeight);

        // calculate scale depending on widget and camera ratios
        var scale = size.aspectRatio * aspectRatio;

        // to prevent scaling down, invert the value
        if (scale < 1) scale = 1 / scale;

        return Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(widget.controllerWrapper.cameraController!),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isInitializing
        ? const Center(
      child: Opacity(opacity: .3, child: CircularProgressIndicator()),
    )
        : widget.controllerWrapper.cameraController != null &&
        (widget.controllerWrapper.cameraController!.value
            .isInitialized &&
            !widget.controllerWrapper.isDisposed)
        ? cameraWidget()
        : isPermissionDenied
        ? Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
          ),
          children: [
            const TextSpan(text: 'Camera access denied, '),
            TextSpan(
              text: 'Open Settings',

              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  openAppSettings();
                },
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    )
        : const SizedBox(
      height: double.infinity,
      width: double.infinity,
    );
  }
}
