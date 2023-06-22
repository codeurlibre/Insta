// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone_app/auth/login_or_register.dart';
import 'package:instagram_clone_app/widgets/follower_botton.dart';

import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final String userProfileId;

  const ProfileScreen({super.key, required this.userProfileId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  String username = "";
  String bio = "";
  String photoUrl = "";
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, _) => user.toFirestore(),
          );

      final docUser = await ref.get();
      final user = docUser.data()!;
      username = user.username;
      bio = user.bio;
      photoUrl = user.photoUrl;

      var userSnap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userProfileId)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection("Posts")
          .where(widget.userProfileId, isEqualTo: currentUser.uid).count()
          .get();

      /*postSnap.then((querySnapshot) {
        setState(){
          postLen = querySnapshot.size;
        }
        print("Nombre de post : $postLen");
      });*/

      postLen = postSnap as int;
      // Returns number of documents in users collection

      userData = userSnap.data() as Map<dynamic, dynamic>;
      setState(() {
        postLen = postSnap as int;
        username = user.username;
        // postLen = int.parse(postSnap as String);
        bio = user.bio;
        photoUrl = user.photoUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text(/*e.toString()*/ "Vous êtes hors ligne")));
    }
  }

  // ? Sign Out user method
  void signOut() async {
    await FirebaseAuth.instance.signOut();

    displayMessage("Your are offline");
  }

  // ? Display a dialog message
  void displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  // * createProfileTopView
  createProfileTopView() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent /*mobileBackgroundColor*/,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(/*userData["username"].toString()*/ username),
          // centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => signOut(), icon: const Icon(Icons.logout))
          ],
        ),
        // appBar: header(context, strTitle: "Profile"),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(/*userData["photoUrl"].toString()*/
                                photoUrl),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(number: postLen, label: "post"),
                                buildStatColumn(
                                    number: 150, label: "followers"),
                                buildStatColumn(number: 09, label: "following"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: FollowButton(
                                    function: () {},
                                    backgroundColor: Colors.black,
                                    borderColor: Colors.grey,
                                    text: "Edit profile",
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      username /*userData["username"].toString()*/,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio /*userData["bio"].toString()*/,
                      /*style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),*/
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              // height: 1,
              color: Colors.grey,
              // thickness: 2,
            )
          ],
        ));
  }

  Column buildStatColumn({required int number, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        )
      ],
    );
  }
}

/*ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(userData["photoUrl"].toString()),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(number: postLen, label: "post"),
                                buildStatColumn(
                                    number: 150, label: "followers"),
                                buildStatColumn(number: 09, label: "following"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: FollowButton(
                                    function: () {},
                                    backgroundColor: Colors.black,
                                    borderColor: Colors.grey,
                                    text: "Edit profile",
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userData["username"].toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userData["bio"].toString(),
                      /*style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),*/
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              // height: 1,
              color: Colors.grey,
              // thickness: 2,
            )
          ],
        )*/
