// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/post.dart';
/*// * User
final currentUser = FirebaseAuth.instance.currentUser!;

// * Is like
bool isLiked = false;

@override
void initState() {
  super.initState();
  isLiked = widget.likes.contains(currentUser.email);
}

// * Toggle like
void toggleLike() {
  setState(() {
    isLiked = !isLiked;
  });

  // * Access the document is Firebase
  DocumentReference postRef =
  FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

  if (isLiked) {
    // if the post is now liked, add the user's email to the 'likes' field
    postRef.update({
      "Likes": FieldValue.arrayUnion([currentUser.email])
    });
  } else {
    // if the post is now unliked, remove the user's email from the 'likes'
    postRef.update({
      "Likes": FieldValue.arrayRemove([currentUser.email])
    });
  }
}*/


class PostView {
  final String description;
  final String username;
  final String postUrl;
  final String profileImage;

  // List<PostModel> allPosts;

  const PostView(
      {required this.description,
      required this.username,
      required this.postUrl,
      required this.profileImage});

//  * View method
  Widget affPost() {
    return Column(
      children: [
        Container(
          // alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 15),
          height: 60,
          // color: Colors.blue,
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profileImage),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                username,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.more_vert)
            ],
          ),
        ),
        // * Part 2
        Container(
          height: 400,
          width: double.infinity,
          // alignment: Alignment.center,
          decoration: const BoxDecoration(color: Colors.white),
          child: Image.network(
            postUrl,
            fit: BoxFit.fill,
          ),
        ),
        // Image.network(src),
        // * Part 3
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.bottomCenter,
              height: 60,
              decoration: const BoxDecoration(color: Colors.purple),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      description,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
