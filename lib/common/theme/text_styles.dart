import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TextStyles {
  static final TextStyles _singleton = TextStyles._internal();

  factory TextStyles() => _singleton;

  TextStyles._internal();

  AppColors appColors = AppColors();

  ///==> COMMON TEXT STYLES GETTERS

  //input text field
  TextStyle get getTextFieldErrorTextStyle =>
      getTextStyle(fontSize: 12, color: AppColors().getErrorColor);

  TextStyle get getTextFieldInputTextStyle => getTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  //dialog
  TextStyle get getDialogTitleTextStyle =>
      getTextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  TextStyle get getDialogBodyTextStyle =>
      getTextStyle(fontSize: 15, fontWeight: FontWeight.normal);

  TextStyle get getDialogBody2TextStyle => getTextStyle(
      fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white);

  ///==> Text Style
  getTextStyle(
      {required double fontSize, Color? color, FontWeight? fontWeight}) {
    TextStyle temp = TextStyle(
        color: color ?? appColors.getPrimaryColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal);
    return temp;
  }
}
