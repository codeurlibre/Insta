// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostModel {
  final String description;
  final String username;
  final String id;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final List<String> likes;

  PostModel({
    required this.description,
    required this.username,
    required this.id,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

//  * To Json method
  Map<String, dynamic> toFirestore() {
    return {
      if (description != null) "description": description,
      if (username != null) "username": username,
      if (id != null) "id": id,
      if (postId != null) "postId": postId,
      if (datePublished != null) "datePublished": datePublished,
      if (postUrl != null) "postUrl": postUrl,
      if (profileImage != null) "profileImage": profileImage,
      if (likes != null) "likes": likes,
    };
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "username": username,
        "id": id,
        // "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes,
      };

// * From snap
  static fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;

    return PostModel(
      description: snapshot["description"],
      username: snapshot["username"],
      id: snapshot["id"],
      postId: snapshot[" postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"],
    );
  }

  //  ? Convertir une collection en objet
  factory PostModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PostModel(
      description: data?['description'],
      username: data?['username'],
      id: data?['id'],
      postId: data?['postId'],
      datePublished: data?['datePublished'],
      postUrl: data?['postUrl'],
      profileImage: data?['profileImage'],
      likes: data?['likes'],
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        description: json["description"],
        username: json["username"],
        id: json["id"],
        postId: json["postId"],
        datePublished: json["datePublished"],
        postUrl: json["postUrl"],
        profileImage: json["profileImage"],
        likes: json["likes"]);
  }
}
