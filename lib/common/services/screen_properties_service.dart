import 'package:flutter/material.dart';


class ScreenPropertiesService {
  static final ScreenPropertiesService _singleton =
      ScreenPropertiesService._internal();

  factory ScreenPropertiesService() {
    return _singleton;
  }

  ScreenPropertiesService._internal();

  double screenWidth = 0;
  double screenHeight = 0;
  Orientation currentOrientation = Orientation.landscape;

  updateScreenProperties(MediaQueryData mQD) {
    currentOrientation = mQD.orientation;
    screenHeight = mQD.size.height;
    screenWidth = mQD.size.width;
/*    Loggy().traceLog("height:: $screenHeight", topic: "ScreenUpdated");
    Loggy().traceLog("width:: $screenWidth", topic: "ScreenUpdated");*/
  }
}
