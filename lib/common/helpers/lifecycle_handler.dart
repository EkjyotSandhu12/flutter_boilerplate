import 'package:flutter/material.dart';
import '../constants/strings_constants.dart';
import '../services/loggy_service.dart';

class Handler extends WidgetsBindingObserver {
  static const handlerTag = 'Handler';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      myLog.traceLog("${Strings.appName} RESUMED");
    }
    if (state == AppLifecycleState.inactive) {
      myLog.traceLog("${Strings.appName} INACTIVE");
    }
    if (state == AppLifecycleState.paused) {
      myLog.traceLog("${Strings.appName} PAUSED");
    }
    if (state == AppLifecycleState.detached) {
      myLog.traceLog("${Strings.appName} DETACHED");
    }
  }
}
