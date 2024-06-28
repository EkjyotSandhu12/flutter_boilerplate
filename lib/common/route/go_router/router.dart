import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/route/go_router/route_middleware.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/module_1/module_1_screen.dart';
import '../../services/reponsive_framework_service.dart';

Widget _myRouteBuilder(BuildContext context, GoRouterState state, Widget child) {
  return ResponsiveFrameworkService().globalResponsive(context, child:  child);
}

final GoRouter goRouter = GoRouter(
  redirect: RouteMiddleware.routeMiddleware,
  routes: <RouteBase>[
    GoRoute(
      path: RouteConstants.sessionScreen,
      builder: (context, state) => _myRouteBuilder(context,
        state,
        const Module1Screen(),
      ),
    ),
  ],
);

abstract class RouteConstants {
  static String sessionScreen = '/';
  static String sessionExecutionScreen = '/sessionExecutionScreen';
}
