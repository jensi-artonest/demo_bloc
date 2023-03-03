import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Auth/AuthModel/auth_repository.dart';
import 'package:untitled3/Auth/HomeSection/home_view.dart';
import 'package:untitled3/Auth/LoginSection/login_view.dart';
import 'package:untitled3/Auth/SignUpSection/sign_up_bloc.dart';
import 'package:untitled3/Auth/SignUpSection/sign_up_view.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "untitled3",
    options: FirebaseOptions(
        apiKey: 'AIzaSyATiIZ-gFzva_HNnqBQN4LssO-e-F5JG7A',
        appId: Platform.isIOS ? '1:874018730122:ios:d2d03409eaba5c79b23d73' : '1:874018730122:android:ee97a33141537e59b23d73',
        messagingSenderId: '',
        projectId: 'loginblo'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => SignUpBloc(authRepository: RepositoryProvider.of<AuthRepository>(context),),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          routes: {
            '/': (context) => const MyHomePage(),
            '/login': (context) => const LogInView(),
            '/login/signup': (context) => const SignUpView(),
            '/home': (context) => const HomeView()
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getPrefData();
  }

  bool? login = false;

  getPrefData() async {
    final prefs = await SharedPreferences.getInstance();
    login = prefs.getBool('login') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return login == false
        ? const LogInView()
        : const HomeView();
  }
}
