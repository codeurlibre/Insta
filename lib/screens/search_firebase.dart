// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class SearchScreenFirebase extends StatefulWidget {
  const SearchScreenFirebase({super.key});

  @override
  State<SearchScreenFirebase> createState() => _SearchScreenFirebaseState();
}

class _SearchScreenFirebaseState extends State<SearchScreenFirebase> {
  TextEditingController searchController = TextEditingController();
  List searchResult = [];
  bool isSearching = false;
  bool isShowUsers = false;

  // * Clear Text form field
  clearTextFormField() {
    searchController.clear();
  }

  // * Search appBar
  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: TextFormField(
          /*onTap: () {
            setState(() {
              isSearching = true;
            });
            print(isSearching);
          },*/
          controller: searchController,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          onFieldSubmitted: (value) {
            setState(() {
              isShowUsers = true;
            });
          },
          /*onChanged: (value) {
            searchItem(value.trim().toLowerCase());
            *//*setState(() {
              name = val;
            });*//*
          },*/
          decoration: InputDecoration(
              filled: true,
              hintText: "Search here...",
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

  searchItem(String searchValue) async {
    // String searchValue = searchController.text.trim().toLowerCase();

    // * Get a reference to the collection you want to search in
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Users');

    // * Define the search query
    QuerySnapshot querySnapshot = await collectionRef
        .where('username', isGreaterThanOrEqualTo: searchValue)
        .get();

    if (querySnapshot.size > 0) {
      setState(() {
        searchResult = querySnapshot.docs.map((e) => e.data()).toList();
      });

      print(searchResult);
    } else {
      print('No matching documents found.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchPageHeader(),
        body: /*isShowUsers? FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("Users")
              .where("username", isGreaterThanOrEqualTo: searchController.text).get(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => print("Tapped"),
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage:
                              NetworkImage((snapshot.data! as dynamic).docs[index]["photoUrl"]),
                            ),
                            title: Text(
                              (snapshot.data! as dynamic).docs[index]["username"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  ),
                );

            },);
          },
        ):Text('Posts')*/ ListView.builder(
          itemCount: searchResult.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => print("Tapped"),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage:
                        NetworkImage(searchResult[index]["photoUrl"]),
                      ),
                      title: Text(
                        searchResult[index]["username"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),)
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

/*
ListView.builder(
itemCount: searchResult.length,
itemBuilder: (context, index) {
return Padding(
padding: const EdgeInsets.all(3),
child: Column(
children: [
GestureDetector(
onTap: () => print("Tapped"),
child: ListTile(
leading: CircleAvatar(
backgroundColor: Colors.black,
backgroundImage:
NetworkImage(searchResult[index]["photoUrl"]),
),
title: Text(
searchResult[index]["username"],
style: const TextStyle(
fontSize: 16, fontWeight: FontWeight.bold),
),
),
)
],
),
);
},
),*/
