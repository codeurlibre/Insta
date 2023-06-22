/*
// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone_app/auth/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;

  // ? Display a dialog message
  void displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

//  ? Upload post
  Future
<String>
 uploadPost(
      {required String description,
      required String username,
      required String id,
        profileImage,
      required Uint8List file}) async {
    try {
      // * Save picture user in firebase storage,
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(childName: "Posts", file: file, isPost: true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
          description: description,
          username: username,
          id: id,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);

      firestore.collection("Posts").doc(currentUser.uid).set(post.toJson());
      // ? Display a dialog message

      displayMessage("Successfully posted");
    } on FirebaseException catch (e) {
      displayMessage(e.code);
      print(e);
    }
    return "";
  }
}
*/
