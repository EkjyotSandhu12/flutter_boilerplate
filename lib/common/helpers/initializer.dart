


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../app_values/global_variables.dart';
import '../services/get_storage_service/get_storage_service.dart';
import '../services/loggy_service.dart';
import '../services/path_provider_service.dart';

abstract class Initializer{
  static init(VoidCallback runApp) async {
    ErrorWidget.builder = (errorDetails) => Center(child: Text(errorDetails.exceptionAsString(),),);
    WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (details) {
        FlutterError.dumpErrorToConsole(details);
      };
      await _initServices();
      runApp();
  }

  static _initServices() async {
    try {
/*    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FireAppCheck().initAppCheck();
      await FirebaseStorageService().initialize();*/
      await GetStorageService().initialize();
      PathProviderService().init();
      GlobalVariables().cameras = await availableCameras();
    } catch (e, stacktrace) {
      myLog.errorLog("initializeError=> $e", stacktrace);
    }
  }
}