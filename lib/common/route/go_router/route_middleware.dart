import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/loggy_service.dart';

abstract class RouteMiddleware {
  static FutureOr<String?> routeMiddleware(
      BuildContext context, GoRouterState state) {
    myLog.infoLog('${state.fullPath}', topic: 'NAVIGATING TO');
  }
}
