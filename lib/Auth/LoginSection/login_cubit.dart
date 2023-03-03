import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Auth/AuthModel/email_validation.dart';
import 'package:untitled3/Auth/AuthModel/password_validation.dart';
import 'package:untitled3/Auth/AuthModel/user_model.dart';
import 'package:untitled3/Auth/LoginSection/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
        email: email, status: Formz.validate([email, state.password])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
        password: password, status: Formz.validate([state.email, password])));
  }

  Future<void> logInWithCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final firebaseAuth = FirebaseAuth.instance;

    if (!state.status.isValidated) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      UserModel userModel = UserModel(
          password: state.password.value,
          email: state.email.value,
          userId: DateTime.now().millisecond.toString(),
          name: state.email.value.split('@').first);
      firebaseAuth
          .signInWithEmailAndPassword(
              email: state.email.value, password: state.password.value)
          .then((value) async {
        final String encodedData = UserModel.encode([userModel]);
        await prefs.setString('loginData', encodedData);
        await prefs.setBool('login', true);
      });
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, error: e.toString()));
    }
  }
}
