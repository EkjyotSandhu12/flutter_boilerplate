import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/text_styles.dart';
import '../../../utils/utils.dart';
import '../../../helpers/input_validators.dart';

class MyInputTextField extends StatelessWidget {
  MyInputTextField(
      {Key? key,
      this.label,
      this.width,
      this.inputType = TextInputType.text,
      this.labelColor,
      this.labelWeight = FontWeight.normal,
      this.initialValue,
      this.textInputAction = TextInputAction.next,
      this.focusNode,
      this.maskTextInputFormatter = const [],
      this.onTap,
      this.onSaved,
      this.onFieldSubmitted,
      this.isDense = true,
      this.textEditingController,
      this.validatorConfig,
      this.labelFactor = 3,
      this.maxLines = 1,
      this.minLines = 1,
      this.floatingLabel = false,
      this.showLabel = true,
      this.showHintText = true,
      this.alignLabelWithHint = false,
      this.textCapitalization = TextCapitalization.sentences,
      this.isReadOnly = false,
      this.enabled = true,
      this.isRequired,
      this.suffixIcon,
      this.prefix,
      this.fillColor = Colors.white,
      this.obscureText = false,
      this.disableAutoFocus = false,
      this.onChanged})
      : super(key: key);

  double? width;
  String? label;
  Color? labelColor;
  FontWeight labelWeight;
  String? initialValue;
  TextInputAction textInputAction;
  TextInputType inputType;
  FocusNode? focusNode;
  Function? onFieldSubmitted;
  Function? onSaved;
  Function? onTap;
  List<TextInputFormatter> maskTextInputFormatter;
  bool isDense;
  final TextEditingController? textEditingController;
  ValidatorConfig? validatorConfig;
  int labelFactor;
  int maxLines;
  int minLines;
  bool floatingLabel;
  bool showLabel;
  bool showHintText;
  bool alignLabelWithHint;
  TextCapitalization textCapitalization;
  bool isReadOnly;
  bool enabled;
  Widget? suffixIcon;
  Widget? prefix;
  Color fillColor;
  Function(String)? onChanged;
  bool obscureText;
  bool? isRequired;
  bool disableAutoFocus;

  FocusNode? _focusNode;

  @override
  Widget build(BuildContext context) {
    _focusNode = focusNode ?? FocusNode();
    return SizedBox(
      width: width,
      child: TextFormField(
        onTapOutside: (v) {
          Utils.hideKeyboard();
        },
        enableInteractiveSelection: true,
        readOnly: isReadOnly,
        enabled: enabled,
        style: TextStyles().textFieldInputTextStyle,
        maxLines: maxLines,
        minLines: minLines,
        textCapitalization: textCapitalization,
        keyboardType: inputType,
        initialValue: initialValue,
        textInputAction: textInputAction,
        inputFormatters: maskTextInputFormatter,
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
      ),
    );
  }
}

