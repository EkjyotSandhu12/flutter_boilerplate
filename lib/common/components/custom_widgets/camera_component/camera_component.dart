import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/route/route_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_values/global_variables.dart';
import '../../../services/loggy_service.dart';
import '../../app_widgets/dialogs/show_dialog.dart';

class CameraControllerWrapper {
  CameraControllerWrapper() {
    assignCameraController();
    reassignController = assignCameraController;
    disposeController = () {
      isDisposed = true;
      return cameraController?.dispose() ?? Future(() {});
    };
  }

  assignCameraController() {
    Loggy().traceLog('assignCameraController executed');
    isDisposed = false;
    if (GlobalVariables().cameras.isNotEmpty) {
      cameraController = CameraController(
        GlobalVariables().cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
    }
  }

  CameraController? cameraController;
  bool isDisposed = false;
  late Future<XFile?> Function() captureImageFunction;
  late Future<void> Function() disposeController;
  late Function() reassignController;
}

///camera component will handle dealing with, complete camera initialization.
///and return a camera preview, which will take as much height and width
///as provided, by its parent container widget
class CameraComponent extends StatefulWidget {
  CameraComponent({super.key, required this.controllerWrapper});

  CameraControllerWrapper controllerWrapper;

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

    Future.delayed(Duration.zero, () {
      initializeCameraController();
    });
  }

  Future<XFile?> captureImage() async {
    Loggy().infoLog("Captured Image", topic: "CameraPage");
    if (!widget.controllerWrapper.cameraController!.value.isInitialized)
      return null;
    try {
      XFile file =
      await widget.controllerWrapper.cameraController!.takePicture();
      return file;
    } catch (e, stacktrace) {
      Loggy().errorLog("Unable to capture image :: $e", stacktrace);
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
        isInitializing = false;
      });
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
              showPermissionDialog();
              break;
          }
        }
      },
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {

    // App state changed before we got the chance to initialize.
    Loggy().traceLog("didChangeAppLifecycleState $state");

    if (!widget.controllerWrapper.cameraController!.value.isInitialized && (await Permission.camera.isDenied)) {
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

  showPermissionDialog() {
    ShowDialog().showSimpleDialog(
      context,
      title: "Camera Access Denied",
      bodyText: "Camera access is required in order to capture images.",
      buttonText: "Open Settings",
      onButtonTap: () {
        openAppSettings();
        RouteService().pop();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  cameraWidget() {
    return ClipRect(
      child: LayoutBuilder(builder: (_, constraints) {
        double aspectRatio = widget.controllerWrapper.cameraController!.value
            .aspectRatio; // Get camera preview height
        //Please note:- this logic is only compatible in parent widget whose 'width' is more than 'height'.
        final size = Size(constraints.maxHeight, constraints.maxWidth);
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
    Loggy().traceLog('isCapturing $isInitializing');
    return isInitializing
        ? Center(
      child: CircularProgressIndicator(
      ),
    )
        : widget.controllerWrapper.cameraController != null &&
        (widget.controllerWrapper.cameraController!.value
            .isInitialized &&
            !widget.controllerWrapper.isDisposed)
        ? cameraWidget()
        : const SizedBox(
      height: double.infinity,
      width: double.infinity,
    );
  }
}
