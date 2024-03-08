import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';


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

}