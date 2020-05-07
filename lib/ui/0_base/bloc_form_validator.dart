import 'package:flutter/widgets.dart';

const String EMAILREGEXP =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const password_upper_case_letter = '[A-Z]';
const password_especial_char = '^[a-zA-Z0-9 ]*\$';

class FormValidatorBloC {
  FormFieldValidator email() {
    FormFieldValidator validator = (value) {
      if (value.toString().isEmpty) {
        return "Field required";//R.string.requiredField;
      } else {
        return _validateEmail(value);
      }
    };
    return validator;
  }

  String _validateEmail(String value) {
    Pattern pattern = EMAILREGEXP;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return "Invalid email";//R.string.invalidEmail;
    else
      return null;
  }

  FormFieldValidator required() {
    FormFieldValidator validator = (value) {
      return (value?.toString()?.trim()?.isEmpty == true)
          ? "Field required"//R.string.requiredField
          : null;
    };
    return validator;
  }
}
