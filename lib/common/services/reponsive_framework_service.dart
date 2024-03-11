import 'package:flutter/material.dart';
import '../theme/theme_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../theme/design_metrics.dart';

class ResponsiveFrameworkService {
//encapsulate any widget inside of this method, and that widget will scale proportionally to ThemeConstants.designScreenWidth
  globalResponsive(BuildContext context, {required Widget child}) {
    return ResponsiveScaledBox(
      width: ResponsiveValue<double>(context, conditionalValues: [
        //Scale:- the application will scale and maintain ratio of designScreenWidth pixels in any resolution by scaling.
        Condition.largerThan(
          breakpoint: 0,
          value: ThemeConstants.designScreenWidth,
        ),
      ]).value,
      child: ClampingScrollWrapper.builder(
        dragWithMouse: true,
        context,
        child,
      ),
    );
  }
}

///Explanation:- any resolution bigger than designScreenWidth, will be multiplied by the increase in pixels. To maintain scaling and proportion
//Condition.between(start: 0, end: 100, value: 50), <- resie after 100. (respect to 50pixel)
///resize:- you can avoid scaling of your application, it will scale in between 0-100 and then simply resize, which is default behaviour by flutter
//we use resize, instead of scale, to change widget layout if screen size is too big.
