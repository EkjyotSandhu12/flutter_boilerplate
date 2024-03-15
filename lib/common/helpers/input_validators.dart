import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../services/loggy_service.dart';
import '../utils/screen_utils.dart';
import '../utils/utils.dart';

class ValidatorConfig {
  List<ValidatorType>?
      validations; // EMPTY, MINLENGTH, MAXLENGTH, EMAIL, PHONE, DATEBEFORE, DATEAFTER, DATE, CCEXPIRY
  var data;
  var minLengthValue;
  var maxLenghtValue;
  BuildContext? buildContext;

  ValidatorConfig(
      {this.validations,
      this.data,
      this.maxLenghtValue,
      this.minLengthValue,
      this.buildContext});
}

class Validator {
  String isValid(
      String? value, ValidatorConfig? validatorConfig, BuildContext context) {
    if (validatorConfig == null) return "";
    value = value == null ? '' : value.trim();
    String validationRes = "";
    for (var validation in validatorConfig.validations!) {
      if (validationRes != '') {
        break;
      }
      switch (validation) {
        case ValidatorType.EMPTY:
          if (value == null) {
            myLog.infoLog("Value is null");
            validationRes += "This field c  annot be empty.";
          } else if (value!.trim().isEmpty) {
            validationRes += "This field cannot be empty.";
          }
          break;
        case ValidatorType.MINLENGTH:
          if (value!.trim().length < validatorConfig.data) {
            validationRes +=
                " Must contain more than ${validatorConfig.data} characters.";
          }
          break;
        case ValidatorType.MAXLENGTH:
          if (value!.trim().length > validatorConfig.data) {
            validationRes +=
                " Must contain at least ${validatorConfig.data} characters.";
          }
          break;
        case ValidatorType.EMAIL:
          if (value == null || value == "") {
            break;
          }
          //This is the regEx as in the backend if it needs updating the backend also needs to be updated
          Pattern emailPattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(emailPattern as String);

          if (!regex.hasMatch(value!)) {
            validationRes += " Invalid email address.";
          }

          break;
/*        case ValidatorType.PHONE: //uses PhoneNumber package
          if (value == null || value == "") {
            break;
          }
          try {
            if (value.trim().isNotEmpty) {
              final phone = PhoneNumber.parse(value.trim(),
                  destinationCountry: IsoCode.ZA);

              myLog.traceLog('phone $phone');
              if (!phone.isValid()) {
                validationRes += " Phone number not valid.";
              }
            }
          } catch (e) {
            myLog.debugLog("PHONE Validation: $e");
            validationRes += " Phone number not valid.";
          }
          break;*/
        case ValidatorType.SAIDNUMBER:
          bool idNumberValid = true;

          if (value!.trim().length != 13) {
            idNumberValid = false;
          }

          try {
            int tempTotal = 0;
            int checkSum = 0;
            int multiplier = 1;
            for (int i = 0; i < 13; i++) {
              tempTotal = int.parse(value![i]) * multiplier;

              if (tempTotal > 9) {
                tempTotal = int.parse(tempTotal.toString()[0]) +
                    int.parse(tempTotal.toString()[1].toString());
              }
              checkSum = checkSum + tempTotal;

              multiplier = (multiplier % 2 == 0) ? 1 : 2;
            }
            if ((checkSum % 10) != 0) {
              idNumberValid = false;
              validationRes += " Invalid SA ID number";
            }
          } catch (error) {
            idNumberValid = false;
            validationRes += " Invalid SA ID number";
          }
          break;
        case ValidatorType.DATEBEFORE:
          if (value!.trim().isNotEmpty) {
            try {
              DateTime date = DateTime.parse(value!);
              if (date.isAfter(DateTime.now())) {
                validationRes += " Date cannot be after current date.";
              }
            } catch (e) {
              myLog.debugLog("$e");
              validationRes += " Invalid Date.";
            }
          }
          break;
        case ValidatorType.DATEAFTER:
          try {
            var d = DateFormat("MM/dd/yyyy").parseStrict(value!);
            if (d.isBefore(DateTime.now())) {
              validationRes += " Date cannot be before current date.";
            }
          } catch (e) {
            validationRes += " Invalid Date.";
          }
          break;
        case ValidatorType.DATE:
          try {
            DateFormat("MM/dd/yyyy").parseStrict(value!);
          } catch (e) {
            validationRes += " Invalid Date.";
          }
          break;
        case ValidatorType.CCEXPIRY:
          try {
            DateTime now = DateTime.now();
            final components = value!.split("/");
            final month = int.tryParse(components[0])!;
            String year = components[1];
            year = now.year.toString().substring(0, 2) + year;
            if (month > 12) {
              validationRes += "CC Expiry Date Invalid. ";
            }
            DateTime ccDate = DateTime(int.tryParse(year)!, month + 1, 0);
            if (ccDate.isBefore(now)) {
              validationRes += "CC Expiry Date Invalid. ";
            }
          } catch (e) {
            validationRes += "CC Expiry Date Invalid. ";
          }
          break;
        case ValidatorType.CCNUMBER:
          try {
            if (value!.isEmpty) {
              validationRes += "CC Number required. ";
            }

            value = value!.replaceAll(' ', '');
            String envVar = const String.fromEnvironment('env');
            if (envVar != "PROD" && value == "4000000000000000") {
              break;
            }
            if (value!.length < 8) {
              // No need to even proceed with the validation if it's less than 8 characters
              validationRes += "CC Number Invalid. ";
            }

            int sum = 0;
            int length = value!.length;
            for (var i = 0; i < length; i++) {
              // get digits in reverse order
              int digit = int.parse(value![length - i - 1]);

              // every 2nd number multiply with 2
              if (i % 2 == 1) {
                digit *= 2;
              }
              sum += digit > 9 ? (digit - 9) : digit;
            }

            if (sum % 10 == 0) {
              break;
            }

            validationRes += "CC Number Invalid. ";
          } catch (e) {
            validationRes += "CC Number Invalid. ";
          }
          break;
        case ValidatorType.ADDRESS:
          if (value == null || value == "") {
            break;
          }
          try {
            if (value!.trim().isEmpty) {
              validationRes += "Invalid Address Details Provided ";
            }
          } catch (e) {
            validationRes += "Invalid Address Details Provided ";
          }
          break;
        case ValidatorType.CONFRIMPASSWORD:
          myLog.debugLog(
              "Validate Confirm Password. Password: ${validatorConfig.data} confirm: $value");
          if ((value != validatorConfig.data) ||
              value!.isEmpty ||
              validatorConfig.data.isEmpty) {
            validationRes += "Password and confirm password must match";
          }
          break;
        case ValidatorType.DIGIT:
          if (value == null || value == "") {
            break;
          }
          if (!Utils.isStringOnlyNumbers(value)) {
            validationRes += "This field can only contain numbers";
          }
          break;
        case ValidatorType.PASSWORD:
          if (value == null || value == "") {
            break;
          }
          RegExp specialCharRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
          RegExp digitRegex = RegExp(r'\d');

          // do password validation

          if (value == null || value!.trim().isEmpty) {
            validationRes += "Password cannot be empty.";
          } else if (value!.length <= 7) {
            validationRes += "Password must contain more than 7 characters";
          } else
          // At least one special character
          if (!specialCharRegex.hasMatch(value!)) {
            validationRes +=
                "Password must contain at least one special character";
          } else
          // At least one numerical value
          if (!digitRegex.hasMatch(value!)) {
            validationRes +=
                "Password must contain at least one numerical value";
          } else
          // At least one uppercase and one lowercase letter
          if (!value!.contains(RegExp(r'[a-z]'))) {
            validationRes +=
                "Password must contain at least one lowercase character";
          } else if (!value!.contains(RegExp(r'[A-Z]'))) {
            validationRes +=
                "Password must contain at least one uppercase character";
          }

          break;
      }
    }

    if (validationRes.isNotEmpty) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 100), alignment: .5);
    }

    return validationRes;
  }
}

enum ValidatorType {
  EMPTY,
  MINLENGTH,
  MAXLENGTH,
  EMAIL,
  // PHONE,
  DATEBEFORE,
  DATEAFTER,
  DATE,
  CCEXPIRY,
  CCNUMBER,
  ADDRESS,
  SAIDNUMBER,
  CONFRIMPASSWORD,
  PASSWORD,
  DIGIT,
}
