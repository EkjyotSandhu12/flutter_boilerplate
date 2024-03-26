import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/route/router.dart';
import 'router.gr.dart';


class RouteService{
  static final RouteService _singleton = RouteService._internal();
  factory RouteService() => _singleton;
  RouteService._internal();

  navigateBack({data}) async {
    return await appRouter.maybePop(data);
  }

  pop({data}) {
    return appRouter.popForced(data);
  }

  //==> SCREENS NAVIGATIONS
  customerDetailsSegment1ViewNavigate() async {
    return await appRouter.push(const Module1Route());
  }


}