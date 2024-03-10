import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/route/router.gr.dart';


class RouteService{
  static final RouteService _singleton = RouteService._internal();
  factory RouteService() => _singleton;
  RouteService._internal();

  navigateBack(BuildContext context, {data}) async {
    return await context.router.pop(data);
  }

  pop(BuildContext context, {data}) {
    return context.router.popForced(data);
  }

  //==> SCREENS NAVIGATIONS
  customerDetailsSegment1ViewNavigate(BuildContext context,
      {Widget? customEndButton}) async {
    return await context.router
        .push(const Module1Route());
  }


}