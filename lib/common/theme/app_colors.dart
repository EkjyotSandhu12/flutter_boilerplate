
import 'package:flutter/material.dart';

class AppColors{
  static final AppColors _singleton = AppColors._internal();
  factory AppColors() => _singleton;
  AppColors._internal();

  ///=> Getter methods to fetch colors based on theme
  //others
  Color get getErrorColor => errorColor;


  //buttons
  Color get getButtonBackgroundColor => primaryColorLight;
  Color get getButtonTextColour => onPrimary;

  //text field
  Color get getCursorColor => onPrimary;
  Color get getTextFieldBackgroundColor => accentColor;
  Color get getTextInputColor => textColorLight;

  //background colors
  Color get getTileBackgroundColor => backgroundColor;
  Color get getTileBackgroundColor2 => tertiaryColorLight;
  Color get getDialogBackgroundColor => backgroundColor;

  //icon
  Color get getIconColor => iconColor;
  Color get getIconBackgroundColor => primaryColorLight;

  //loaders
  Color get getLoaderColor => primaryColorLight;



  ///==> Define your color variables here
/*  Color _primaryColorDark = Color(0xFF000000);
  Color _accentColorDark = Color(0xFF666666);
  Color _textColorDark = Color(0xFFFFFFFF);
  */
  Color primaryColorLight = Color(0xffEFBC9B);
  Color onPrimary = Colors.white;
  Color secondaryColorLight = Color(0xFFFBF3D5);
  Color tertiaryColorLight = Color(0xff9CAFAA);
  Color accentColor = Color(0xffD6DAC8);
  Color textColorLight = Color(0xFF000000);
  Color backgroundColor = Colors.white;
  Color iconColor = Colors.white;
  Color errorColor = Colors.red;




  ///======================================================///
  //=> Boolean variable to track current theme
  ValueNotifier<bool>  isDarkTheme = ValueNotifier<bool>(false);
  // Method to switch between dark and light themes
  void switchTheme() {
    isDarkTheme.value = !isDarkTheme.value;
  }

  // Method to manually set the theme
  void setDarkTheme(bool isDark) {
    isDarkTheme.value = isDark;
  }
  
  
  
}