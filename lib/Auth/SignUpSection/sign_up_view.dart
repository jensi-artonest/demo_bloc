import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/Auth/AuthModel/auth_repository.dart';
import 'package:untitled3/Auth/SignUpSection/sign_up_bloc.dart';
import 'package:untitled3/Auth/SignUpSection/sign_up_from_widget.dart';


class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Welcome to SignUp"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => SignUpBloc(authRepository: RepositoryProvider.of<AuthRepository>(context),),
          child: const SignUpFormWidget(),
        ),
      ),
    );
  }
}