import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/common/common_widgets/app_widgets/snackbar/snack_bar_ui.dart';

class ShowSnackBars {
  _commonShowSnackBar(BuildContext context,
      {required String text,
      required SnackBarType snackBarType,
      bool disableAutoClose = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Duration duration = Duration(milliseconds: min(2500, text.length * 80));

    //it takes around 90ms to read one character
    final snackBar = SnackBarUI(
      snackBarType: snackBarType,
      text: text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        duration: disableAutoClose ? const Duration(hours: 1) : duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.only(top: 5),
      ),
    );
  }

  showErrorSnackBar(BuildContext context,
      {required String text, bool disableAutoClose = false}) {
    _commonShowSnackBar(
      context,
      text: text,
      snackBarType: SnackBarType.error,
      disableAutoClose: disableAutoClose,
    );
  }

  showInfoSnackBar(BuildContext context,
      {required String text, bool disableAutoClose = false}) {
    _commonShowSnackBar(
      context,
      text: text,
      snackBarType: SnackBarType.info,
      disableAutoClose: disableAutoClose,
    );
  }

  showSuccessSnackBar(BuildContext context,
      {required String text, bool disableAutoClose = false}) {
    _commonShowSnackBar(
      context,
      text: text,
      snackBarType: SnackBarType.success,
      disableAutoClose: disableAutoClose,
    );
  }

}
