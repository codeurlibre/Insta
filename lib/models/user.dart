// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String photoUrl;
  final String username;
  final String id;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final List listLetter;

  UserModel({
    required this.photoUrl,
    required this.username,
    required this.id,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.listLetter,
  });

//  * To Json method
  Map<String, dynamic> toFirestore() {
    return {
      if (photoUrl != null) "photoUrl": photoUrl,
      if (username != null) "username": username,
      if (id != null) "id": id,
      if (email != null) "email": email,
      if (bio != null) "bio": bio,
      if (followers != null) "followers": followers,
      if (following != null) "following": following,
      if (listLetter != null) "listLetter": listLetter,
    };
  }

  Map<String, dynamic> toJson() => {
        "photoUrl": photoUrl,
        "username": username,
        "id": id,
        "email": email,
        "bio": bio,
        "followers": followers,
        "following": following,
        "listLetter": listLetter,
      };

// * From snap
  static fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;

    return UserModel(
        photoUrl: snapshot["photoUrl"],
        username: snapshot["username"],
        id: snapshot["id"],
        email: snapshot["email"],
        bio: snapshot["bio"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        listLetter: snapshot["listLetter"]);
  }

  //  ? Convertir une collection en objet
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      photoUrl: data?['photoUrl'],
      username: data?['username'],
      id: data?['id'],
      email: data?['email'],
      bio: data?['bio'],
      followers: data?['followers'],
      following: data?['following'],
      listLetter: data?['listLetter'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        photoUrl: json["photoUrl"],
        username: json["username"],
        id: json["id"],
        email: json["email"],
        bio: json["bio"],
        followers: json["followers"],
        following: json["following"],
        listLetter: json["listLetter"]);
  }
}
