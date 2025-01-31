import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TextStyles {
  static final TextStyles _singleton = TextStyles._internal();

  factory TextStyles() => _singleton;

  TextStyles._internal();

  ///==> COMMON TEXT STYLES GETTERS

  TextStyle get displayLarge => getOutfitTextStyle(
      fontSize: 57.0, fontWeight: FontWeight.w400, letterSpacing: -0.25);

  TextStyle get displayMedium => getOutfitTextStyle(
      fontSize: 45.0, fontWeight: FontWeight.w400, letterSpacing: 0.0);

  TextStyle get displaySmall => getOutfitTextStyle(
      fontSize: 36.0, fontWeight: FontWeight.w400, letterSpacing: 0.0);

  TextStyle get headlineLarge => getOutfitTextStyle(
      fontSize: 32.0, fontWeight: FontWeight.w400, letterSpacing: 0.0);

  TextStyle get headlineMedium => getOutfitTextStyle(
      fontSize: 28.0, fontWeight: FontWeight.w400, letterSpacing: 0.0);

  TextStyle get headlineSmall => getOutfitTextStyle(
      fontSize: 24.0, fontWeight: FontWeight.w400, letterSpacing: 0.0);

  TextStyle get titleLarge => getOutfitTextStyle(
      fontSize: 22.0, fontWeight: FontWeight.w400, letterSpacing: 0.0);

  TextStyle get titleMedium => getOutfitTextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.15);

  TextStyle get titleSmall => getOutfitTextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1);

  TextStyle get bodyLarge => getOutfitTextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5);

  TextStyle get bodyMedium => getOutfitTextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.25);

  TextStyle get bodySmall => getOutfitTextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4);

  TextStyle get labelLarge => getOutfitTextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.1);

  TextStyle get labelMedium => getOutfitTextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.5);

  TextStyle get labelSmall => getOutfitTextStyle(
      fontSize: 12.0, fontWeight: FontWeight.w500, letterSpacing: 0.5);

  ///==> Text Styles

  ///body style
  TextStyle getOutfitTextStyle(
      {required double fontSize,
        Color? color,
        FontWeight? fontWeight,
        double? height,
        double? letterSpacing,}) {
    TextStyle temp = TextStyle(
      fontFamily: 'outfit',
      height: height,
      color: color ?? AppColors().getPrimaryColor,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      letterSpacing: letterSpacing,
    );
    return temp;
  }


}
