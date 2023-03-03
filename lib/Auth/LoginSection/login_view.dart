import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/Auth/LoginSection/login_cubit.dart';
import 'package:untitled3/Auth/LoginSection/login_from_widget.dart';


class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Welcome to Login"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => LoginCubit(),
          child:LoginFormWidget(),
        ),
      ),
    );
  }
}
