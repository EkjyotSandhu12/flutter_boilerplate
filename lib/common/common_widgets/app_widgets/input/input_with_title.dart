import 'package:flutter/material.dart';
import 'my_input_text_field.dart';

class CheckBoxWithTitle {
  CheckBoxWithTitle({
    required this.title,
    required this.onSelected,
  });

  String title;
  Function(bool) onSelected;
  bool isSelected = false;
}

class CheckboxesInputsWithTitleHeader extends StatefulWidget {
  CheckboxesInputsWithTitleHeader({
    super.key,
    required this.title,
    required this.checkboxesWithTitles,
    this.width,
    this.titleStyle,
  });

  List<CheckBoxWithTitle> checkboxesWithTitles;
  String title;
  TextStyle? titleStyle;
  double? width;

  @override
  State<CheckboxesInputsWithTitleHeader> createState() =>
      _CheckboxesInputsWithTitleHeaderState();
}

class _CheckboxesInputsWithTitleHeaderState
    extends State<CheckboxesInputsWithTitleHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              widget.title,
              style: widget.titleStyle ??
                  CustomTextStyles().getF15TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: ThemeConstants().titleAndTxtFieldGap,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1.4,
                  color: ThemeService().theme.darkText.withOpacity(.3),
                )),
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...widget.checkboxesWithTitles.map((e) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.title,
                        style: CustomTextStyles().getF15TextStyle(),
                      ),
                      Spacer(),
                      CustomCheckBox(
                        onChange: (value) {
                          e.onSelected(value);
                          widget
                              .checkboxesWithTitles[
                                  widget.checkboxesWithTitles.indexOf(e)]
                              .isSelected = value;
                          setState(() {});
                        },
                        border: BorderSide(
                            color:
                                ThemeService().theme.darkText.withOpacity(.3)),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum TextFieldType { password, phone }

class InputWithTextTitleHeader extends StatelessWidget {
  InputWithTextTitleHeader({
    super.key,
    this.title,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
    this.width,
    this.suffixIcon,
    this.lines = 1,
    this.isObscure = false,
    this.titleStyle,
    this.validatorConfig,
    this.textEditingController,
    this.textFieldType,
    this.inputType,
  });

  String? title;
  TextStyle? titleStyle;
  bool enabled;
  bool readOnly;
  String? initialValue;
  Widget? suffixIcon;
  bool isObscure;
  double? width;
  int lines;
  ValidatorConfig? validatorConfig;
  TextEditingController? textEditingController;
  TextFieldType? textFieldType;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              title ?? '',
              style: titleStyle ??
                  CustomTextStyles().getF15TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: ThemeConstants().titleAndTxtFieldGap,
          ),
          textFieldType == TextFieldType.password
              ? PasswordInputTextField(
                  passwordEditingController: textEditingController,
                  validatorConfig: validatorConfig,
                  label: '',
                )
              : textFieldType == TextFieldType.phone
                  ? PhoneNumberInputTextField(
                      phoneNumberEditingController: textEditingController,
                      label: '',
                      suffixIcon: suffixIcon,
                    )
                  : MyInputTextField(
                      inputType: inputType ?? TextInputType.text,
                      validatorConfig: validatorConfig,
                      isReadOnly: readOnly,
                      obscureText: isObscure,
                      suffixIcon: suffixIcon,
                      minLines: lines,
                      maxLines: lines,
                      label: "",
                      textEditingController: textEditingController,
                      initialValue: initialValue,
                      enabled: enabled,
                    ),
        ],
      ),
    );
  }
}

class AutofillInputWithTextTitleHeader extends StatelessWidget {
  AutofillInputWithTextTitleHeader({
    super.key,
    required this.title,
    this.enabled = true,
    this.initialValue,
    this.width,
    this.label = "",
    this.suffixIcon,
    this.lines = 1,
    this.isObscure = false,
    this.isSimpleDropDown = false,
    this.textEditingController,
    required this.options,
    this.headingStyle,
    this.validatorConfig,
    this.onSelected,
  });

  final List<String> options;
  final String title;
  String label;
  bool enabled;
  String? initialValue;
  Widget? suffixIcon;
  bool isObscure;
  bool isSimpleDropDown;
  double? width;
  int lines;
  TextEditingController? textEditingController;
  ValidatorConfig? validatorConfig;
  TextStyle? headingStyle;
  Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              title,
              style: headingStyle ??
                  CustomTextStyles().getF15TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: ThemeConstants().titleAndTxtFieldGap,
          ),
          CustomAutofillInputField(
            onSelected: onSelected,
            isSimpleDropDown: isSimpleDropDown,
            textEditingController: textEditingController,
            obscureText: isObscure,
            suffixIcon: suffixIcon,
            minLines: lines,
            label: label,
            initialValue: initialValue,
            enabled: enabled,
            options: options,
            validatorConfig: validatorConfig,
          ),
        ],
      ),
    );
  }
}
