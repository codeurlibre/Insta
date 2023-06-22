import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/header_widget.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? username;

  @override
  Widget build(BuildContext context) {
    submitUserName() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();

        SnackBar snackBar = SnackBar(content: Text("Welcome $username"));
        scaffoldKey.currentState!
            .showSnackBar(SnackBar(
          // duration: const Duration(seconds: 4),
            content: Text("Welcome $username")));
        Timer(const Duration(seconds: 4), () {
          Navigator.pop(context, username);
        });
      }
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: header(context, strTitle: "Settings", disableBackButton: true),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 26),
                  child: Center(
                    child: Text(
                      "Set up a username",
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(17),
                  child: Container(
                    child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            username = value;
                          },
                          validator: (value) {
                            if (value!.trim().length < 5 || value.isEmpty) {
                              return "Username is very short";
                            } else if (value.trim().length > 15) {
                              return "Username is very long";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 16),
                            hintText: "Must be atleast, 5 characters",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: submitUserName,
                  child: Container(
                    height: 55,
                    width: 360,
                    decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text("Proceed",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
