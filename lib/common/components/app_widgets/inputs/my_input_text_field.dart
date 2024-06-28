import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../helpers/input_validators.dart';
import '../../../theme/text_styles.dart';
import '../../../utils/utils.dart';


class MyInputTextField extends StatelessWidget {
  MyInputTextField({
    super.key,
    this.hintText,
    this.inputType = TextInputType.text,
    this.labelColor,
    this.labelWeight = FontWeight.normal,
    this.initialValue,
    this.maskTextInputFormatter = const [],
    this.onTap,
    this.onSaved,
    this.onFieldSubmitted,
    this.textEditingController,
    this.validatorConfig,
    this.maxLines = 1,
    this.minLines = 1,
    this.textCapitalization = TextCapitalization.sentences,
    this.isReadOnly = false,
    this.enabled = true,
    this.suffixIcon,
    this.prefix,
    this.fillColor = Colors.white,
    this.obscureText = false,
    this.onChanged,
    this.disableAutoFocus = false,
  });

  String? hintText;
  Color? labelColor;
  FontWeight labelWeight;
  String? initialValue;
  TextInputType inputType;
  Function? onFieldSubmitted;
  Function? onSaved;
  Function? onTap;
  List<TextInputFormatter> maskTextInputFormatter;
  final TextEditingController? textEditingController;
  ValidatorConfig? validatorConfig;
  int maxLines;
  int minLines;
  TextCapitalization textCapitalization;
  bool isReadOnly;
  bool enabled;
  Widget? suffixIcon;
  Widget? prefix;
  Color fillColor;
  Function(String)? onChanged;
  bool obscureText;
  bool disableAutoFocus;

  InputBorder inputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  );

  inputTextFieldInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyles().getTextFieldInputTextStyle,
      isDense: true,
      errorStyle: TextStyles().getTextFieldErrorTextStyle,
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(),
      disabledBorder: inputBorder(),
      border: inputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (v) {
        Utils.hideKeyboard();
      },
      decoration: inputTextFieldInputDecoration(hintText: hintText),
      enableInteractiveSelection: true,
      readOnly: isReadOnly,
      enabled: enabled,
      style: TextStyles().getTextFieldInputTextStyle,
      maxLines: maxLines,
      minLines: minLines,
      textCapitalization: textCapitalization,
      keyboardType: inputType,
      initialValue: initialValue,
      obscureText: obscureText,
      onFieldSubmitted: (term) {
        try {
          if (onFieldSubmitted != null) {
            onFieldSubmitted!();
          } else {
            print('no function');
          }
        } catch (e) {
          print(e);
        }
      },
      controller: textEditingController,
      validator: (val) {
        String _error = Validator().isValid(val, validatorConfig, context);
        return _error != "" ? _error : null;
      },
      onChanged: (val) {
        if (onChanged != null) {
          onChanged!(val);
        }
      },
      onSaved: (val) {
        try {
          if (onSaved != null) {
            onSaved!();
          }
        } catch (e) {
          print(e);
        }
      },
      onTap: () {
        if (!disableAutoFocus && !isReadOnly) {
          Utils.ensureVisibleTextField(context);
        }
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}
