import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  // ? Sign Out user method
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    displayMessage("Your are offline");
  }

  // ? Display a dialog message
  void displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text("Web"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => signOut(), icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text(
          "Web",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
