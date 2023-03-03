// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  void _confirmPasswordChange(
      ConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    final password = ConfirmPassword.dirty(
        password: state.password.value, value: event.confirmPassword);
    emit(state.copyWith(
        confirmPassword: password, status: Formz.validate([password])));
  }

  void _emailChange(EmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email, status: Formz.validate([email])));
  }

  UserModel deviceifo(
      {required String password,
      required String name,
      required String email,
      required String userId,
      required String userDeviceId,
      required String userDeviceModel,
      required String userDeviceToken,
      required String userDeviceType}) {
    return deviceifo(
        password: password,
        name: name,
        email: email,
        userId: userId,
        userDeviceId: userDeviceId,
        userDeviceModel: userDeviceModel,
        userDeviceToken: userDeviceToken,
        userDeviceType: userDeviceType);
  }

  Future<void> _formSubmission(
      FormSubmission event, Emitter<SignUpState> emit) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;
    var iosInfo = await deviceInfoPlugin.iosInfo;
    final firebaseAuth = FirebaseAuth.instance;
    final prefs = await SharedPreferences.getInstance();
    if (!state.status.isValidated) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await authRepository.SignIn(
          name: state.name.value.isNotEmpty.toString(),
          email: state.email.value.isNotEmpty.toString(),
          password: state.password.value.isNotEmpty.toString());
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

        firebaseAuth
            .createUserWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        )
            .then((value) async {
          var userModel = UserModel(
            password: state.password.value,
            name: state.name.value,
            email: state.email.value,
            userId: value.user!.uid,
            userDeviceId: Platform.isAndroid
                ? androidInfo.id
                : iosInfo.identifierForVendor,
            userDeviceModel:
                Platform.isAndroid ? androidInfo.board : iosInfo.name,
            userDeviceType:
                Platform.isAndroid ?  "Android" : "iOS",
          );

          final databaseRef = FirebaseDatabase.instance.reference();
          await databaseRef.push().set(UserModel.toMap(userModel));
          // await prefs.setString(
          //     'loginData',
          //     UserModel.encode([
          //       UserModel(
          //           userId: DateTime.now().millisecond.toString(),
          //           name: state.name.value,
          //           password: state.password.value,
          //           email: state.email.value)
          //     ]));

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
