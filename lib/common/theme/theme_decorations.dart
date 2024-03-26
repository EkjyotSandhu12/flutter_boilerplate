import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'text_styles.dart';

//theme decoration class may contain all the decorations, text field decoration, containers decoration which will be reusable or used globally
class ThemeDecorations {
  static final ThemeDecorations _singleton = ThemeDecorations._internal();
  factory ThemeDecorations() => _singleton;
  ThemeDecorations._internal();


  TextStyles textStyles = TextStyles();

  ///==> Containers

  BoxDecoration containerInnerShadowDecoration() => BoxDecoration(
        boxShadow: [],
      );

  BoxShadow commonContainerBoxShadow() {
    return BoxShadow(
      blurStyle: BlurStyle.outer,
      color: Colors.black.withOpacity(.2),
      spreadRadius: .1,
      blurRadius: 4,
    );
  }

  ///==> TEXT INPUT FIELD DECORATIONS

  InputBorder inputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          width: 1.4,
        ),
      );

  inputTextFieldInputDecoration(String hintText, String displaySuffix,
      {String selectedCountry = '_selectedCountry1',
      bool isDense = false,
      double borderRadius = 15.0,
      Widget? suffixIcon,
      bool showLabel = false,
      bool hintTextAsHint = false,
      bool alignLabelWithHint = false,
      bool showBorder = true,
      bool isRequired = false,
      Widget? prefix}) {
    double leftMarginPadding = 8.0;
    return InputDecoration(
      alignLabelWithHint: true,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hintText),
          Text(
            isRequired ? " *" : "",
            style: textStyles.textFieldInputTextStyle,
          )
        ],
      ),
      labelStyle: textStyles.textFieldInputTextStyle,
      isDense: true,
      contentPadding: EdgeInsets.only(
          left: prefix != null ? 0 : 20,
          top: 15,
          bottom: 15,
          right: suffixIcon != null ? 0 : 20),
      // contentPadding: EdgeInsets.all(5),
      errorStyle: textStyles.textFieldErrorTextStyle,
      enabledBorder: ThemeDecorations().inputBorder(),
      focusedBorder: ThemeDecorations().inputBorder(),
      disabledBorder: ThemeDecorations().inputBorder(),
      border: ThemeDecorations().inputBorder(),
      prefixIconConstraints: const BoxConstraints(maxHeight: 25),
      suffixIconConstraints: const BoxConstraints(),

      prefixIcon: prefix != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: prefix,
            )
          : null,
      suffixIcon: suffixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 4),
              child: suffixIcon,
            )
          : null,
    );
  }
}
