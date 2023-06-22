// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:instagram_clone_app/screens/login_screen.dart';
import 'package:instagram_clone_app/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // * Initially, show the login
  bool showLoginPage = true;

  // * Toggle between login or register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
      print(showLoginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(onTap: togglePages);
    } else {
      return RegisterScreen(onTap: togglePages);
    }
  }
}
