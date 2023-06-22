// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/auth/firestore_methods.dart';
import 'package:instagram_clone_app/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_app/screens/time_line_screen.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../auth/storage_methods.dart';
import '../generated/assets.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import 'upload_screen.dart';

class AddPostScreen extends StatefulWidget {
  // final UserModel gUser;
  const AddPostScreen({
    super.key,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? image;
  final currentUser = FirebaseAuth.instance.currentUser!;
  late TextEditingController descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
  }

  // * Select image function
  selectImage(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text(
                "Create a post",
              ),
              titlePadding: const EdgeInsets.only(left: 80, top: 15),
              children: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      chooseImage(ImageSource.camera);

                      /*Uint8List file = await pickImage(ImageSource.camera);
                      setState(() {
                        image = file;
                      });*/
                    },
                    child: const Text("Take a photo")),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      chooseImage(ImageSource.gallery);
                      /*Uint8List file = await pickImage(ImageSource.gallery);
                      setState(() {
                        image = file;
                      });*/
                    },
                    child: const Text("Choose from gallery")),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ));
  }

  // * Post image function
  postImage({required Uint8List file}) async {
    try {
      // * Show loading linear progressive
      setState(() {
        isLoading = true;
      });

      // * Save picture post in firebase storage,
      String photoUrl = await StorageMethods().uploadImageToStorage(
          childName: "PostPics", file: file, isPost: true);

      // * Post model
      String postDescription = descriptionController.text;

      final ref = FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, _) => user.toFirestore(),
          );

      final docUser = await ref.get();
      final user = docUser.data()!;
      String postId = const Uuid().v1();

      // * DocumentSnapshot snapshot = collectionRef.doc().
      PostModel post = PostModel(
          description: postDescription,
          username: user.username,
          id: user.id,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: user.photoUrl,
          likes: []);

      // * Create a new document in cloud firestore called Posts
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .set(post.toFirestore());
      displayMessage("successfully posted");
      print("successfully posted");
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      displayMessage(e.code);
      print(e);
    }
  }

// ? Select image
  void chooseImage(ImageSource source) async {
    Uint8List img = await pickImage(source);
    setState(() {
      image = img;
    });
  }

  // ? Clear info post
  clearInfoPost() {
    descriptionController.clear();
    setState(() {
      isLoading = false;
      image = null;
    });
  }

  void displayMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  Widget build(BuildContext context) {
    return image == null
        ? IconButton(
            onPressed: () {
              selectImage(context);
            },
            icon: const Icon(
              Icons.add_photo_alternate,
              size: 90,
            ))
        : Scaffold(
            //UploadScreen
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text("Post to"),
// centerTitle: true,
                leading: IconButton(
                    onPressed: clearInfoPost,
                    icon: const Icon(Icons.arrow_back)),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await postImage(file: image!);
                        clearInfoPost();
                        /*setState(() {
                          isLoading = false;
                        });*/
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ))
                ]),
            body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                // * Get user data
                if (snapshot.hasData) {
                  final currentUser =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      isLoading ? const LinearProgressIndicator() : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 58,
                            width: 58,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
// Assets.imagesDefaultProfilePicture
                                    image:
                                        NetworkImage(currentUser["photoUrl"]))),
                          ),
                          // * Comment session
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white.withOpacity(0.2),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              cursorWidth: 2,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.none,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  hintText: "Write a\ncaption.."),
                            ),
                          ),
                          SizedBox(
                            height: 55,
                            width: 55,
                            child: AspectRatio(
                              aspectRatio: 2 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        alignment: FractionalOffset.topCenter,
                                        fit: BoxFit.cover,
                                        image: MemoryImage(image!))),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                      /*  Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
// shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                fit: BoxFit.cover,
// Assets.imagesDefaultProfilePicture
                                image: MemoryImage(image!))),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(currentUser["bio"])*/
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.hasError}"),
                  );
                }
                return const Text("");

                /*return const Center(
                  child: CircularProgressIndicator(),
                );*/
              },
            ),
          );
  }
}
