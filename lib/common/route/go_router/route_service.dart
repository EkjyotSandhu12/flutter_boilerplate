import 'package:flutter_boilerplate/common/route/go_router/router.dart';

class RouteService {
  static final RouteService _singleton = RouteService._internal();
  factory RouteService() => _singleton;
  RouteService._internal();

  pop({data}) {
    return goRouter.pop();
  }

  //==> SCREENS NAVIGATION
  sessionExecutionScreenNavigate() async {
    goRouter.push(RouteConstants.sessionExecutionScreen);
  }
}
