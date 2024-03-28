import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'route_middleware.dart';
import 'router.gr.dart';
import '../services/reponsive_framework_service.dart';

//read README.md or docs
final appRouter = AppRouter();
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  List<String> excludeScaling = [
    // Login.page.name,
    // CaptureLicenseDiskPlateView.page.name
    // VehicleCapturedImageView.page.name
  ];

  Route<T> playRouteBuilder<T>(
      BuildContext context,
      Widget child,
      AutoRoutePage<T> page,
      ) {
    return PageRouteBuilder(
      reverseTransitionDuration: Duration.zero,
      transitionDuration: Duration.zero,
      settings: page,
      pageBuilder: (_, animation, ___) => excludeScaling.contains(page.name)
          ? child
          : ResponsiveFrameworkService().globalResponsive(context, child: child),
    );
  }

  CustomRoute customRoute<T>(
      {required PageInfo<dynamic> page, bool initial = false}) =>
      CustomRoute(
        guards: [
          AuthGuard(),
        ],
        customRouteBuilder: playRouteBuilder,
        initial: initial,
        page: page,
      );

  @override
  List<AutoRoute> get routes => [
    ///==> Individual/Solo Routes
    customRoute(
      initial: true,
      page: Module1Route.page,
    ),
  ];
}
