// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/models/user.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:instagram_clone_app/widgets/button_input.dart';
import 'package:instagram_clone_app/widgets/text_field_input.dart';

import '../auth/storage_methods.dart';
import '../generated/assets.dart';
import '../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;

  const RegisterScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  Uint8List? image;

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController.text.toLowerCase() ==
        usernameController.text.toUpperCase();
  }*/

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  bool inLoginProcess = false;

  // ? Sign up user method
  void signUp({required Uint8List file}) async {
    // * Show loading circle
    setState(() {
      inLoginProcess = true;
    });

    // * Make sure passwords match
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      // Show error to user
      setState(() {
        inLoginProcess = false;
      });
      displayMessage("Passwords don't match!");
      return;
    }

    // * Try creating user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      displayMessage("Account successfully created");

      // * Save picture user in firebase storage,
      String photoUrl = await StorageMethods().uploadImageToStorage(
          childName: "ProfilePics", file: file, isPost: false);

      List<String> letters = [];

      String strUserName = usernameController.text;
      String temp = "";
      for (var i = 0; i < strUserName.length; i++) {
        if (strUserName[i] == " ") {
          temp = "";
        } else {
          strUserName = usernameController.text.toLowerCase();
          temp = temp + strUserName[i];
          if (strUserName.contains(temp.toLowerCase())) {
            letters.add(temp);
          }
        }
      }

      // String str = usernameController.text.toLowerCase();

      // * User model
      UserModel user = UserModel(
        photoUrl: photoUrl,
        username: strUserName,
        id: userCredential.user!.uid,
        email: emailController.text,
        bio: bioController.text,
        followers: [],
        following: [],
        listLetter: letters,
      );

      // * After creating the user, create a new document in cloud firestore called Users
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set(user.toFirestore());

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

  // ? Select image
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // * Svg image
                    SvgPicture.asset(
                      Assets.imagesIcInstagram,
                      colorFilter:
                          const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                      height: 50,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // * Circular picture file
                    Stack(
                      children: [
                        image != null
                            ? Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        // Assets.imagesDefaultProfilePicture
                                        image: MemoryImage(image!))),
                              )
                            : CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.blue,
                                child: Container(
                                  height: 125,
                                  width: 125,
                                  decoration: const BoxDecoration(
                                      // color: Colors.t,

                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          // Assets.imagesDefaultProfilePicture
                                          image: AssetImage(Assets
                                              .imagesDefaultProfilePicture))),
                                ),
                              ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: blueColor.withOpacity(0.5),
                            child: GestureDetector(
                              onTap: selectImage,
                              child: const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // * TextField input for username
                    TextFieldInput(
                        textEditingController: usernameController,
                        type: TextInputType.name,
                        isPass: false,
                        hintText: "Username"),
                    const SizedBox(
                      height: 15,
                    ),

                    // * TextField input for email
                    TextFieldInput(
                        textEditingController: emailController,
                        type: TextInputType.emailAddress,
                        isPass: false,
                        hintText: "Email"),
                    const SizedBox(
                      height: 15,
                    ),

                    // * TextField input for password
                    TextFieldInput(
                        textEditingController: passwordController,
                        type: TextInputType.text,
                        isPass: true,
                        hintText: "Password"),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldInput(
                        textEditingController: confirmPasswordController,
                        type: TextInputType.text,
                        isPass: true,
                        hintText: "Confirm password"),
                    const SizedBox(
                      height: 15,
                    ),
                    // * TextField input for bio
                    TextFieldInput(
                        textEditingController: bioController,
                        type: TextInputType.text,
                        isPass: false,
                        hintText: "Enter your bio.."),
                    const SizedBox(
                      height: 15,
                    ),

                    // * Button for login

                    inLoginProcess
                        ? const Center(child: CircularProgressIndicator())
                        : MyButton(
                            onTap: () => signUp(file: image!), text: "Sign up"),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                // * Transitioning to signing up

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white.withOpacity(0.8)),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign in",
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
        ),
      ),
    );
  }
}
