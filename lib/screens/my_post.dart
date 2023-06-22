import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/post.dart';
import '../widgets/like_button.dart';

class MyPost extends StatefulWidget {
  final String description;
  final String username;
  final String postUrl;
  final String profileImage;
  final String postId;
  final String datePublished;
  final List<String> likes;

  const MyPost(
      {super.key,
      required this.description,
      required this.username,
      required this.postUrl,
      required this.profileImage,
      required this.postId,
      required this.datePublished,
      required this.likes});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  // * User
  final currentUser = FirebaseAuth.instance.currentUser!;

// * Is like
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // * Toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //  * Access the document firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("Posts").doc(widget.postId);

    if (isLiked) {
      //  * If the post is now liked, add the user email to the 'likes' field
      postRef.update({
        "likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //  * If the unliked, remove the user's email from the 'likes' field
      postRef.update({
        "likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 60,
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.profileImage),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.username,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              GestureDetector(onTap: () {}, child: const Icon(Icons.more_vert))
            ],
          ),
        ),
        // * Part 2
        Container(
          height: MediaQuery.of(context).size.width / 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              image: DecorationImage(
                image: NetworkImage(
                  widget.postUrl,
                ),
                fit: BoxFit.fill,
              )),
        ),
        // Image.network(src),
        // * Part 3
        Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    LikeButton(isLiked: isLiked, onTap: toggleLike),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/commenter.png",
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/envoyer.png",
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/enregistrer-instagram.png",
                        height: 28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // * Like count
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.likes.length.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const Text(
                      " J'aime",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            // * Part 4 DESCRIPTION AND NUMBER OF COMMENTS
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: widget.username,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " ${widget.description}")
                ]),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                alignment: Alignment.bottomLeft,
                child: const Text("Views 55 comments",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              width: double.infinity,
              child: Text(widget.datePublished,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            )

            /*  Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.bottomCenter,
              height: 60,
              decoration: const BoxDecoration(color: Colors.purple),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.description,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),*/
          ],
        )
      ],
    );
  }
}
