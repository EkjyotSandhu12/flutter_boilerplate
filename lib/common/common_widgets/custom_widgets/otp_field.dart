import 'package:flutter/material.dart';

import '../../services/loggy_service.dart';
import '../../theme/theme_decorations.dart';
import '../../utils/utils.dart';

class OtpFieldController {
  late bool Function() validate;
  String? otpString;
}

class OTPField extends StatefulWidget {
  final int totalFields;
  final OtpFieldController otpFieldController;

  OTPField({required this.totalFields, required this.otpFieldController});

  @override
  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late List<TextEditingController> _controllers;
  bool showErrorString = true;
  String errorString = '';

  @override
  void initState() {
    super.initState();
    widget.otpFieldController.validate = validate;
    _controllers =
        List.generate(widget.totalFields, (index) => TextEditingController());

  }

  String getEnteredValues() {
    String otpString = '';
    _controllers.forEach((controller) => otpString += controller.text);
    Loggy().infoLog("OTP STRING => $otpString", topic: "getEnteredValues");
    return otpString.trim();
  }

  bool validate() {
    String otpString = getEnteredValues();
    widget.otpFieldController.otpString = null;
    if (otpString.isEmpty) {
      errorString = "Please enter the complete OTP.";
      setState(() {
        showErrorString = true;
      });
      return false;
    }
    if (!Utils.isStringOnlyNumbers(otpString)) {
      errorString = "Only numerical digits are allowed.";
      setState(() {
        showErrorString = true;
      });
      return false;
    }
    if (otpString.length < widget.totalFields) {
      errorString = "Please enter the complete OTP.";
      setState(() {
        showErrorString = true;
      });
      return false;
    }
    setState(() {
      showErrorString = false;
    });
    widget.otpFieldController.otpString = otpString;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                widget.totalFields,
                    (index) {
                  return Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 50,
                        child: TextFormField(
                          onTapOutside: (e) {
                            Utils.hideKeyboard();
                          },
                          onTap: () {
                            Utils.ensureVisibleTextField(context);
                            _controllers[index].selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _controllers[index].text.length),
                                );
                          },
                          onChanged: (value) {
                            if (_controllers[index].text.length == 1 &&
                                index < widget.totalFields) {
                              if (index == widget.totalFields - 1) {
                                FocusScope.of(context).unfocus();
                              } else {
                                if (_controllers[index + 1].text.isNotEmpty) {
                                  return;
                                } else {
                                  FocusScope.of(context).nextFocus();
                                }
                              }
                            } /*else if (_controllers[index].text.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }*/
                          },
                          controller: _controllers[index],
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: ThemeDecorations().inputBorder(),
                            focusedBorder: ThemeDecorations()
                                .inputBorder()
                                .copyWith(
                                borderSide: BorderSide(
                                    color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),);
                },
              ),
            ]),
        SizedBox(
          height: 4,
        ),
        if (showErrorString)
          Text(
            "$errorString",
            style: TextStyle(color: Colors.red),
          )
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
