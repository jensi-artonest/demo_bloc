// ignore_for_file: body_might_complete_normally_nullable

import 'package:formz/formz.dart';

enum NameError {invalid,empty}
class Name extends FormzInput<String,NameError>{
  const Name.pure([String? value = '']) : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);
  static final RegExp nameRegExp = RegExp(r'^(?=.*[a-z])[A-Za-z ]{2,}$');
  @override
  NameError? validator(String? value) {
    if(value!.isEmpty){
      return null;
    }
    return nameRegExp.hasMatch(value) ? null : NameError.invalid;
  }

}