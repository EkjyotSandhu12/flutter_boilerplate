import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';

class ShowSnackBars {
  _commonShowSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    //it takes around 90ms to read one character
    Duration duration = Duration(milliseconds: max(1400, text.length * 80));

    final snackBar = SnackBar(
      duration: duration,
      content: Text('${text}'),
      action: SnackBarAction(
        label: AppStrings.close,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showSimpleSnackBar(BuildContext context, {required String text}) {
    _commonShowSnackBar(context, text);
  }
}
