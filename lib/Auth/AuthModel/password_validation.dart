// ignore_for_file: body_might_complete_normally_nullable

import 'package:formz/formz.dart';

enum PasswordValidatorError {invalid,empty}
class Password extends FormzInput<String,PasswordValidatorError>{
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);
  static final RegExp passwordRegExp = RegExp(
      r'^[A-Za-z\d@$!%*?&]{8,}$');
  @override
  PasswordValidatorError? validator(String? value) {
    if(value!.isEmpty){
      return null;
    }
    return passwordRegExp.hasMatch(value) == true
        ? null
        : PasswordValidatorError.invalid;
  }

}