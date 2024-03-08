import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/theme/app_colors.dart';

class TextStyles {
  static final TextStyles _singleton = TextStyles._internal();

  factory TextStyles() => _singleton;

  TextStyles._internal();

  AppColors appColors = AppColors();

  ///==> TEXT STYLES GETTERS
  TextStyle get titleFont => _getF20TextStyle(fontWeight: FontWeight.bold);
  TextStyle get titleFont2 => _getF15TextStyle(fontWeight: FontWeight.bold);
  TextStyle get textFieldErrorStyle => _getF12TextStyle(fontWeight: FontWeight.bold);
  TextStyle get textFieldInputText => _getF14TextStyle(fontWeight: FontWeight.bold);


  ///==> Text Styles
  TextStyle _getF20TextStyle({Color? color, FontWeight? fontWeight}) {
    TextStyle temp = TextStyle(
        color: appColors.textColor,
        fontSize: 20,
        fontWeight: fontWeight ?? FontWeight.normal);
    return temp;
  }

  TextStyle _getF15TextStyle({Color? color, FontWeight? fontWeight}) {
    TextStyle temp = TextStyle(
        color: appColors.textColor,
        fontSize: 15,
        fontWeight: fontWeight ?? FontWeight.normal);
    return temp;
  }

  TextStyle _getF14TextStyle({Color? color, FontWeight? fontWeight}) {
    TextStyle temp = TextStyle(
        color: appColors.textColor,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal);
    return temp;
  }

  TextStyle _getF12TextStyle({Color? color, FontWeight? fontWeight}) {
    TextStyle temp = TextStyle(
        color: appColors.textColor,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal);
    return temp;
  }
}
