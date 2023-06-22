import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';

import '../utils/colors.dart';

import '../widgets/progress_widget.dart';
import 'my_post.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({super.key});

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      // reverse: true,
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            toolbarHeight: 60,
            floating: true,
            snap: true,
            // pinned: true,

            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),

            title: SvgPicture.asset(
              "assets/images/ic_instagram.svg",
              colorFilter:
                  const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              height: 30,
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/images/facebook-messenger.png",
                    color: Colors.white,
                  ))
            ],
          )
        ];
      },
      body: StreamBuilder(
          // .orderBy("datePublished")
          stream: FirebaseFirestore.instance
              .collection("Posts")
              .orderBy("datePublished", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                // reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index].data();

                  return MyPost(
                      description: post["description"],
                      username: post["username"],
                      postUrl: post["postUrl"],
                      profileImage: post["profileImage"],
                      postId: post["postId"],
                      datePublished: DateFormat.yMMMd()
                          .format(post["datePublished"].toDate()),
                      likes: List<String>.from(post["likes"] ?? []));
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.hasError}"),
              );
            }
            return circularProgress();
          }),
    ));
  }
}

/*StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Posts")
              .orderBy("datePublished")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index];
                  /*PostView postView = PostView(
                      description: post["description"],
                      username: post["username"],
                      postUrl: post["postUrl"],
                      profileImage: post["profileImage"]);*/
                  // postView.affPost()
                  return MyPost(
                      description: post["description"],
                      username: post["username"],
                      postUrl: post["postUrl"],
                      profileImage: post["profileImage"],
                      postId: post.id,
                      likes: List<String>.from(post["likes"] ?? []));
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.hasError}"),
              );
            }
            return circularProgress();
          }),*/
