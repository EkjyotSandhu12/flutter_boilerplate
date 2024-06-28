import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TextStyles {
  static final TextStyles _singleton = TextStyles._internal();

  factory TextStyles() => _singleton;

  TextStyles._internal();

  AppColors appColors = AppColors();

  ///==> COMMON TEXT STYLES GETTERS

  TextStyle get getAppBarTextStyle => TextStyles().getPoppinsTextStyle(fontSize: 22, fontWeight: FontWeight.normal);

  //input text field
  TextStyle get getTextFieldErrorTextStyle => getKarlaTextStyle(fontSize: 12, color: AppColors().getErrorColor);
  TextStyle get getTextFieldInputTextStyle => getKarlaTextStyle(fontSize: 18, fontWeight: FontWeight.w300);

  //dialog
  TextStyle get getDialogTitleTextStyle => getPoppinsTextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  TextStyle get getDialogBodyTextStyle => getKarlaTextStyle(fontSize: 15, fontWeight: FontWeight.normal);



  ///==> Text Styles

  ///body style
  getKarlaTextStyle(
      {required double fontSize,
        Color? color,
        FontWeight? fontWeight,
        double? height}) {
    TextStyle temp = TextStyle(
      fontFamily: 'Karla',
      height: height,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
    return temp;
  }

  ///Titles style
  getPoppinsTextStyle(
      {required double fontSize,
        Color? color,
        FontWeight? fontWeight,
        double? height}) {
    TextStyle temp = TextStyle(
      fontFamily: 'Poppins',
      height: height,
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: fontSize,
    );
    return temp;
  }
}
