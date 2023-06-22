// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone_app/widgets/button_input.dart';
import 'package:instagram_clone_app/widgets/text_field_input.dart';

import '../generated/assets.dart';
import '../models/user.dart' as model;
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;

  const LoginScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // In login process
  bool inLoginProcess = false;

  // ? Sign In user method
  void signIn() async {
    // * Show loading circle
    setState(() {
      inLoginProcess = true;
    });

    // * Try login user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      displayMessage("Your are connected");
      // * Pop loading circle
    } on FirebaseException catch (e) {
      // * Pop loading circle
      setState(() {
        inLoginProcess = false;
      });
      // * Display error message
      displayMessage(e.code);
      print(e.code);
    }
  }

  // ? Display a dialog message
  void displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  // * Svg image
                  SvgPicture.asset(
                    Assets.imagesIcInstagram,
                    colorFilter:
                        const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 64,
                  ),
                  const SizedBox(
                    height: 64,
                  ),

                  // * TextField input for email
                  TextFieldInput(
                      textEditingController: emailController,
                      type: TextInputType.emailAddress,
                      isPass: false,
                      hintText: "Email"),
                  const SizedBox(
                    height: 25,
                  ),

                  // * TextField input for password
                  TextFieldInput(
                      textEditingController: passwordController,
                      type: TextInputType.text,
                      isPass: true,
                      hintText: "Password"),
                  const SizedBox(
                    height: 25,
                  ),

                  // * Button for login
                  inLoginProcess
                      ? const Center(child: CircularProgressIndicator())
                      : MyButton(onTap: signIn, text: "Login"),
                  const SizedBox(
                    height: 18,
                  ),

                  // * Forgot details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot your details? ",
                        style: TextStyle(
                            fontSize: 16, color: Colors.white.withOpacity(0.8)),
                      ),
                      GestureDetector(
                        onTap: () => print("Get help logging in"),
                        child: const Text(
                          "Get help logging in",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: blueColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  // * ----------OR----------
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 1,
                        // width: ,
                        color: Colors.grey,
                      )),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("OR"),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // * Facebook login
                  GestureDetector(
                    onTap: () => print("Login with Facebook"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      blueColor, BlendMode.srcIn),
                                  image: AssetImage(
                                      Assets.imagesIcCirculaireFacebook))),
                        ),
                        const Text(
                          " Login with Facebook",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: blueColor),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 140,
              ),

              // * Transitioning to signing up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8)),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
