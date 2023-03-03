import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Auth/AuthModel/auth_repository.dart';
import 'package:untitled3/Auth/AuthModel/confrim_password_validation.dart';
import 'package:untitled3/Auth/AuthModel/email_validation.dart';
import 'package:untitled3/Auth/AuthModel/name_validation.dart';
import 'package:untitled3/Auth/AuthModel/password_validation.dart';
import 'package:untitled3/Auth/AuthModel/user_model.dart';


part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;
  SignUpBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<PasswordChanged>(_passwordChange);
    on<NameChanged>(_nameChange);
    on<ConfirmPasswordChanged>(_confirmPasswordChange);
    on<EmailChanged>(_emailChange);
    on<FormSubmission>(_formSubmission);
  }

  void _passwordChange(PasswordChanged event, Emitter<SignUpState> emit) {
    final password = Password.dirty(event.password);
    emit(
        state.copyWith(password: password, status: Formz.validate([password])));
  }

  void _nameChange(NameChanged event, Emitter<SignUpState> emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(name: name, status: Formz.validate([name])));
  }

  void _confirmPasswordChange(ConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    final password = ConfirmPassword.dirty(
        password: state.password.value, value: event.confirmPassword);
    emit(state.copyWith(
        confirmPassword: password, status: Formz.validate([password])));
  }

  void _emailChange(EmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email, status: Formz.validate([email])));
  }

  Future<void> _formSubmission(FormSubmission event, Emitter<SignUpState> emit) async {
    final firebaseAuth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();
    if (!state.status.isValidated) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await authRepository.SignIn(name: state.name.value.isNotEmpty.toString(), email: state.email.value.isNotEmpty.toString(), password: state.password.value.isNotEmpty.toString());
      List<UserModel> userData = [];
        List<UserModel> userModel = userData;
        if (state.name.value.isNotEmpty &&
            state.password.value.isNotEmpty &&
            state.confirmPassword.value.isNotEmpty &&
            state.email.value.isNotEmpty) {
          userModel.add(UserModel(
              userId: DateTime.now().millisecond.toString(),
              name: state.name.value,
              password: state.password.value,
              email: state.email.value));

          firebaseAuth.createUserWithEmailAndPassword(email: state.email.value, password: state.password.value).then((value)async{
            final String encodedData = UserModel.encode(userModel);
            await prefs.setString('userData', encodedData);
            await prefs.setString(
                'loginData',
                UserModel.encode([
                  UserModel(
                      userId: DateTime.now().millisecond.toString(),
                      name: state.name.value,
                      password: state.password.value,
                      email: state.email.value)
                ]));

            await prefs.setBool('login', true);
          });
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } else {
          emit(state.copyWith(
              error: "Please fill the all details",
              status: FormzStatus.submissionCanceled));
        }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, error: e.toString()));
    }
  }
}
