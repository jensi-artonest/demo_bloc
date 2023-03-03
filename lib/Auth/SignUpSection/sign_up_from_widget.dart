
// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:untitled3/Auth/AuthModel/user_model.dart';
import 'package:untitled3/Auth/SignUpSection/sign_up_bloc.dart';
import 'package:untitled3/custom_text_feild.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
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
              content: Text(state.exceptionError.toString()),backgroundColor: Colors.purple.shade100,
            ));
        } else if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("User register successfully!!"),backgroundColor: Colors.purple.shade100,
            ));

          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(38, 0, 38, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const _NameInputField(),
            _EmailInputField(),
            const _PasswordInputField(),
            const _ConfirmPasswordInput(),
            const _SignUpButton(),
            const _LoginButton()
          ],
        ),
      ),
    );
  }

}


class _NameInputField extends StatelessWidget {
  const _NameInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 16),
          child: CustomTextFiled(
            hint: 'Name',
            error: state.name.error != null ? state.name.error!.name : null,
            key: const Key('signup_name'),
            keyboardType: TextInputType.text,
            isRequiredField: true,
            onChange: (name) =>
                context.read<SignUpBloc>().add(NameChanged(name: name)),
          ),
        );
      },
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CustomTextFiled(
              hint: "Email",
              error: state.email.error != null ? state.email.error!.name : null,
              key: const Key('signup_email'),
              isRequiredField: true,
              keyboardType: TextInputType.emailAddress,
              onChange: (email) =>
                  context.read<SignUpBloc>().add(EmailChanged(email: email)),
            ));
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  const _PasswordInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomTextFiled(
              isRequiredField: true,
              isPasswordField: true,
              key: const Key('signup_password'),
              hint: 'Password',
              error: state.password.error != null
                  ? state.password.error!.name
                  : null,
              onChange: (password) => context
                  .read<SignUpBloc>()
                  .add(PasswordChanged(password: password)),
              keyboardType: TextInputType.text),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
      previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return CustomTextFiled(
            isPasswordField: true,
            isRequiredField: true,
            hint: 'Confirm Password',
            key: const Key('signup_confirmPassword'),
            error: state.confirmPassword.error != null
                ? state.confirmPassword.error!.name
                : null,
            onChange: (confirmPassword) => context
                .read<SignUpBloc>()
                .add(ConfirmPasswordChanged(confirmPassword: confirmPassword)),
            keyboardType: TextInputType.text);
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            disabledColor: Colors.purpleAccent.withOpacity(0.6),
            color: Colors.purpleAccent,
            onPressed: state.status.isValidated
                ? () {
              context.read<SignUpBloc>().add(const FormSubmission());
              DatabaseService.getUser();
              addData(state.name.value, state.email.value, state.password.value);
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
                : const Text("Sign Up"),
          ),
        );
      },
    );
  }
  void addData(String name, String email, String password) {
    final databaseRef = FirebaseDatabase.instance.reference();
    databaseRef
        .push()
        .set({'password': password, 'email': email, 'name': name});
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            disabledColor: Colors.purpleAccent.withOpacity(0.6),
            color: Colors.purpleAccent,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text("Back to login"),
          ),
        );
      },
    );
  }
}

class DatabaseService {
  static getUser() async {
    DataSnapshot userSnapshot =
    await FirebaseDatabase.instance.reference().child("user").get();

    print("++++++++++++++++++++++ ${userSnapshot.value}");

    List<UserModel> user = [];
    return user;

    // Map<dynamic, dynamic> values = userSnapshot.value.;
    // userSnapshot.value!.forEach((key, values) {
    //   user.add(UserModel.fromjson(values));
    // });
    //
    // return user;
  }
}