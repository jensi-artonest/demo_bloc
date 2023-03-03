// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Auth/AuthModel/user_model.dart';
import 'package:untitled3/Auth/HomeSection/home_bloc.dart';
import 'package:untitled3/Auth/HomeSection/home_event.dart';
import 'package:untitled3/Auth/HomeSection/home_state.dart';
import 'package:untitled3/Auth/HomeSection/user_repo.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(UserRepository())..add(const LoadUserEvent()),
      child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is UserErrorState) {
          return Scaffold(body: Center(child: Text("ERROR OCCURRED")));
        }
        else if (state is UserLoadedState) {
          List<UserModel> users = state.userData;
          List<UserModel> loginData = state.userLogin;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (loginData.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      final firebaseAuth = FirebaseAuth.instance;
                      firebaseAuth.currentUser;
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('loginData');
                      await prefs.setBool('login', false);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('LogOut'),
                  ),
                ],
              ),
            ),
            body: Center(
              child: Container(
                height: 100,
                width: 100,
               child:Text("Welcome ${loginData.first.name}",style: TextStyle(color: Colors.black,fontSize: 15),),
              ),
            ),
          );
        }
        return Container();
      }),
    );
  }
}
