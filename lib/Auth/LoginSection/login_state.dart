import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:untitled3/Auth/AuthModel/email_validation.dart';
import 'package:untitled3/Auth/AuthModel/password_validation.dart';

class LoginState extends Equatable {
  final Email email;
  final Password password;
  final FormzStatus status;

  final String exceptionError;

  const LoginState(
      {this.email = const Email.pure(),
        this.password = const Password.pure(),
        this.status = FormzStatus.pure,
        this.exceptionError = ''});

  @override
  List<Object?> get props => [email, password, status];

  LoginState copyWith(
      {Email? email, Password? password, FormzStatus? status, String? error}) {
    return LoginState(
        status: status ?? this.status,
        exceptionError: error ?? exceptionError,
        email: email ?? this.email,
        password: password ?? this.password);
  }
}