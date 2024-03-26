import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/loggy_service.dart';
import '../../values/global_variables.dart';


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
    myLog.traceLog('assignCameraController executed');
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
    myLog.infoLog("Captured Image", topic: "CameraPage");
    if (!widget.controllerWrapper.cameraController!.value.isInitialized)
      return null;
    try {
      XFile file =
          await widget.controllerWrapper.cameraController!.takePicture();
      return file;
    } catch (e, stacktrace) {
      myLog.errorLog("Unable to capture image :: $e", stacktrace);
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
    myLog.traceLog("didChangeAppLifecycleState $state");

    if (!widget.controllerWrapper.cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      widget.controllerWrapper.disposeController();
    } else if (state == AppLifecycleState.resumed) {
      myLog.traceLog(
          'controllerWrapper => ${widget.controllerWrapper.isDisposed}');
      if (true/*||await Permission.camera.isGranted*/) {
        widget.controllerWrapper.reassignController();
        initializeCameraController();
      }
    }
  }

  showPermissionDialog() {
    //navigate user to open settings and grant the permission
/*    ShowDialog().showSimpleDialog(
      context,
      titleText: "Camera Access Denied",
      bodyText: "Camera access is required in order to capture images.",
      buttonText: "Open Settings",
      onButtonTap: () {
        openAppSettings();
        NavigationService().pop(context);
      },
    );*/
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  cameraWidget() {
    double scale = widget.controllerWrapper.cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(widget.controllerWrapper.cameraController!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myLog.traceLog('isCapturing $isInitializing');
    return isInitializing
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors().getLoaderColor,
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
