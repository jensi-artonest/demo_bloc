import 'package:formz/formz.dart';

enum ConfirmPasswordValidatorError{invalid,mismatch,empty}
class ConfirmPassword extends FormzInput<String,ConfirmPasswordValidatorError>{
  final String password;
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.password,String value = ''}) : super.dirty(value);

  @override
  ConfirmPasswordValidatorError? validator(String value) {
   if(value.isEmpty){
     return null;
   }
   return password == value ?null :ConfirmPasswordValidatorError.mismatch;
  }
}