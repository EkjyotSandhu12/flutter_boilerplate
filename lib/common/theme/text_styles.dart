import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TextStyles {
  static final TextStyles _singleton = TextStyles._internal();

  factory TextStyles() => _singleton;

  TextStyles._internal();

  AppColors appColors = AppColors();

  ///==> TEXT STYLES GETTERS
  //buttons
  TextStyle get boldButtonTextStyle => _getF18TextStyle(fontWeight: FontWeight.w500);

  //input text field
  TextStyle get textFieldErrorTextStyle => _getF12TextStyle(color: Colors.red);
  TextStyle get textFieldInputTextStyle => _getF18TextStyle(fontWeight: FontWeight.w500, color: AppColors().getTextFieldBackgroundColor);

  //dialog
  TextStyle get dialogTitleTextStyle => _getF18TextStyle(fontWeight: FontWeight.w500);
  TextStyle get dialogBodyTextStyle => _getF15TextStyle(fontWeight: FontWeight.normal);
  TextStyle get dialogBody2TextStyle => _getF18TextStyle(fontWeight: FontWeight.normal, color: Colors.white);

  ///==> Text Styles
  TextStyle _getF18TextStyle({Color? color, FontWeight? fontWeight}) {
    return _getTextStyle(fontSize: 18, color: color, fontWeight: fontWeight);
  }
  TextStyle _getF15TextStyle({Color? color, FontWeight? fontWeight}) {
    return _getTextStyle(fontSize: 15, color: color, fontWeight: fontWeight);
  }
  TextStyle _getF12TextStyle({Color? color, FontWeight? fontWeight}) {
    return _getTextStyle(fontSize: 12, color: color, fontWeight: fontWeight);
  }

  _getTextStyle(
      {required double fontSize, Color? color, FontWeight? fontWeight}) {
    TextStyle temp = TextStyle(
        color: color ?? appColors.getTextInputColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal);
    return temp;
  }
}
