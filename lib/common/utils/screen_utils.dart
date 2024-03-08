import 'dart:async';
import 'package:flutter/material.dart';


abstract class ScreenUtils {
  ///==> UI
  static double getScreenHeight(BuildContext context,
      {double ratio = 1, bool removeInsect = false}) {
    MediaQueryData md = MediaQuery.of(context);

    return MediaQuery.of(context).size.height * ratio -
        (removeInsect ? (md.padding.vertical + md.viewInsets.vertical) : 0);
  }

  static double getScreenWidth(BuildContext context,
      {double ratio = 1, bool removeInsect = false}) {
    MediaQueryData md = MediaQuery.of(context);

    return MediaQuery.of(context).size.width * ratio -
        (removeInsect ? (md.padding.horizontal + md.viewInsets.horizontal) : 0);
  }


//Anything like keyboard
  static double viewInsetsBottom(BuildContext context, {double ratio = 1}) {
    //this will return anything that comes up on display like keyboard
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static double viewPaddingBottom(BuildContext context, {double ratio = 1}) {
    //even if keyboard is up, it will return the system ui block padding
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static double viewPaddingTop(BuildContext context, {double ratio = 1}) {
    //even if keyboard is up, it will return the system ui block padding
    return MediaQuery.of(context).viewPadding.top;
  }

  static double viewPaddingLeft(BuildContext context, {double ratio = 1}) {
    //even if keyboard is up, it will return the system ui block padding
    return MediaQuery.of(context).viewPadding.left;
  }

  static double viewPaddingRight(BuildContext context, {double ratio = 1}) {
    //even if keyboard is up, it will return the system ui block padding
    return MediaQuery.of(context).viewPadding.right;
  }

  static double viewPaddingVer(BuildContext context, {double ratio = 1}) {
    //even if keyboard is up, it will return the system ui block padding
    return viewPaddingTop(context) + viewPaddingBottom(context);
  }

  static double viewPaddingHor(BuildContext context, {double ratio = 1}) {
    //even if keyboard is up, it will return the system ui block padding
    return viewPaddingLeft(context) + viewPaddingRight(context);
  }


  static double paddingBottom(BuildContext context, {double ratio = 1}) {
    //if keyboard is up, it will return keyboard padding, if not then system ui block padding
    return MediaQuery.of(context).padding.bottom;
  }




}


