// ignore_for_file: body_might_complete_normally_nullable

import 'package:formz/formz.dart';

enum EmailValidatorError {invalid,empty}
class Email extends FormzInput<String,EmailValidatorError>{
  const Email.pure([String? value = '']) : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);
  static final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
  @override
  EmailValidatorError? validator(String? value) {
    if(value!.isEmpty){
      return null;
    }
    return emailRegExp.hasMatch(value)
        ? null
        : EmailValidatorError.invalid;
  }

}