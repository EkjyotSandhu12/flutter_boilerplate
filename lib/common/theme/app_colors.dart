
import 'package:flutter/material.dart';

class AppColors{
  static final AppColors _singleton = AppColors._internal();
  factory AppColors() => _singleton;
  AppColors._internal();


  ///==> Define your color variables here
// Primary and Secondary Colors
  final Color getPrimaryColor =  Color(0xFF00ADB5);
  final Color getOnPrimaryColor = Color(0xffEEEEEE); // Color used on top of primaryColor
  final Color getSecondaryColor = Color(0xFF222831);
  final Color getSecondaryColor2 = Color(0xFF393E46);

// Accent and Highlight Colors
  final Color getErrorColor = Colors.red;

// Background and Icon Colors
  final Color getScaffoldBackgroundColor = Colors.white;




  ///======================================================///
  //=> Boolean variable to track current theme
  ValueNotifier<bool>  isDarkTheme = ValueNotifier<bool>(false);
  // Method to switch between dark and light themes
  // Method to manually set the theme
  void setTheme(bool isDark) {
    isDarkTheme.value = isDark;
  }



}