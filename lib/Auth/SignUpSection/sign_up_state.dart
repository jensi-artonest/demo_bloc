part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzStatus.pure,
    this.exceptionError,
  });

  final Name name;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzStatus status;
  final String? exceptionError;

  @override
  List<Object> get props =>
      [name, email, password, confirmPassword, status];

  SignUpState copyWith(
      {String? image,
        Name? name,
        Email? email,
        Password? password,
        ConfirmPassword? confirmPassword,
        FormzStatus? status,
        String? error}) {
    return SignUpState(
      name: name ?? this.name,
      password: password ?? this.password,
      status: status ?? this.status,
      email: email ?? this.email,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      exceptionError: error ?? exceptionError,
    );
  }
}
class UnAuthenticated extends SignUpState{
  @override
  List<Object> get props => [];
}