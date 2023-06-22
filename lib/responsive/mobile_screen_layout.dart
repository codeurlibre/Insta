// ignore_for_file: avoid_print
import 'dart:ui';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone_app/utils/colors.dart';

import '../screens/add_post_screen.dart';
import '../screens/firebase_search_screen.dart';
import '../screens/new_user_search.dart';
import '../screens/notitications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_firebase.dart';
import '../screens/search_screen.dart';
import '../screens/time_line_screen.dart';
import '../screens/upload_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late PageController pageController;
  var focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  // * Type index
  int selectedPage = 0;

  void onTappedBar(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  // focusNode.hasFocus?null :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: mobileBackgroundColor,
            selectedItemColor: primaryColor,
            unselectedItemColor: secondaryColor,
            currentIndex: selectedPage,
            onTap: onTappedBar,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.camera_alt,
                  size: 36,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "",
              ),
            ]),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (index) {
            onPageChanged(index);
          },
          children: [
            // CloudFirestoreSearch(),
            // SearchScreen(),

            // FirebaseSearchScreen(),
            // SearchScreenFirebase(),
            TimeLineScreen(),
            NewUserSearch(),
            // UploadScreen(),
            AddPostScreen(),
            NotificationsScreen(),
            ProfileScreen(userProfileId: currentUser.uid),
          ],
        ));
  }
}
