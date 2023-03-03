// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:untitled3/Auth/LoginSection/login_cubit.dart';
import 'package:untitled3/Auth/LoginSection/login_state.dart';
import 'package:untitled3/custom_text_feild.dart';

class LoginFormWidget extends StatelessWidget {
   LoginFormWidget({super.key});
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("Invalid credentials"),backgroundColor: Colors.purple.shade100,
            ));
        } else if (state.status.isSubmissionCanceled) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("This credential do not match to our records."),backgroundColor: Colors.purple.shade100
            ));
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("Login successfully"),backgroundColor: Colors.purple.shade100
            ));

          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(38, 0, 38, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    _EmailInputField(),
                    _PasswordInputField(),
                    _LoginButton(),
                    const _SignUpButton()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextFiled(
          hint: 'Email',
          key: const Key('email_login'),
          keyboardType: TextInputType.emailAddress,
          error: state.email.error != null ? state.email.error!.name : null,
          onChange: (email) => context.read<LoginCubit>().emailChanged(email),
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextFiled(
          onChange: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.symmetric(vertical: 20),
          hint: 'Password',
          isPasswordField: true,
          key: const Key('password_login'),
          error:
              state.password.error != null ? state.password.error!.name : null,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CupertinoButton(
              disabledColor: Colors.purpleAccent.withOpacity(0.6),
              color: Colors.purpleAccent,
              padding: EdgeInsets.zero,
              onPressed: state.status.isValidated
                  ? () {
                      context.read<LoginCubit>().logInWithCredentials();
                    }
                  : null,
              child: state.status.isSubmissionInProgress
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      // color: Colors.red,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ))
                  : const Text('Login')),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            disabledColor: Colors.purpleAccent.withOpacity(0.6),
            color: Colors.purpleAccent,
            onPressed: () => Navigator.pushNamed(context, '/login/signup'),
            child: const Text("Sign Up"),
          ),
        );
      },
    );
  }
}
