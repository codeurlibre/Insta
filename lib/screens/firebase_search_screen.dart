// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseSearchScreen extends StatefulWidget {
  const FirebaseSearchScreen({super.key});

  @override
  State<FirebaseSearchScreen> createState() => _FirebaseSearchScreenState();
}

class _FirebaseSearchScreenState extends State<FirebaseSearchScreen> {
  TextEditingController searchText = TextEditingController();
  List searchResults = [];
  String name = "";

  // * Clear Text form field
  clearTextFormField() {
    searchText.clear();
  }

  // * Search from firebase
  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: searchText.text)
        .get();

    setState(() {
      searchResults = result.docs.map((e) => e.data()).toList();
    });
  }

  // * Search appBar
  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: TextFormField(
        controller: searchText,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          onChanged: (query) {
            searchFromFirebase(query);
            /*setState(() {
              name = val;
            });*/
          },
          decoration: InputDecoration(
              filled: true,
              hintText: "Search here..",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              suffixIcon: IconButton(
                onPressed: clearTextFormField,
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => print("Tapped"),
                  child: ListTile(
                    /*leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(""),
                      ),*/
                    title: Text(
                      searchResults[index]["username"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
