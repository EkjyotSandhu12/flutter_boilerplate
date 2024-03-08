
import 'package:flutter/material.dart';

class AppColors{
  static final AppColors _singleton = AppColors._internal();
  factory AppColors() => _singleton;
  AppColors._internal();

  ///=> Getter methods to fetch colors based on theme
  Color get primaryColor => isDarkTheme.value ? _primaryColorDark : _primaryColorLight;
  Color get accentColor => isDarkTheme.value ? _accentColorDark : _accentColorLight;
  Color get textColor => isDarkTheme.value ? _textColorDark : _textColorLight;


  ///==> Define your color variables here
  Color _primaryColorDark = Color(0xFF000000);
  Color _accentColorDark = Color(0xFF666666);
  Color _textColorDark = Color(0xFFFFFFFF);
  //
  Color _accentColorLight = Color(0xFFCCCCCC);
  Color _primaryColorLight = Color(0xFFFFFFFF);
  Color _textColorLight = Color(0xFF000000);



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