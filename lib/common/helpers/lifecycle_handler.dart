import 'package:flutter/material.dart';
import '../app_values/app_strings.dart';
import '../services/loggy_service.dart';

class Handler extends WidgetsBindingObserver {
  static const handlerTag = 'Handler';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      myLog.traceLog("${AppStrings.appName} RESUMED");
    }
    if (state == AppLifecycleState.inactive) {
      myLog.traceLog("${AppStrings.appName} INACTIVE");
    }
    if (state == AppLifecycleState.paused) {
      myLog.traceLog("${AppStrings.appName} PAUSED");
    }
    if (state == AppLifecycleState.detached) {
      myLog.traceLog("${AppStrings.appName} DETACHED");
    }
  }
}
