import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/screens/feed_screen.dart';
import 'package:lvtn_mangxahoi/screens/home_screens.dart';
import 'package:lvtn_mangxahoi/screens/profile_screen.dart';
import 'package:lvtn_mangxahoi/screens/search_screen.dart';

import '../screens/add_post_screen.dart';

import 'package:lvtn_mangxahoi/utils/key_shared.dart';
import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';

const webScreenSize = 600;

final uid = FirebaseFirestore.instance.collection('users').doc().id;

// ignore: non_constant_identifier_names
List<Widget> HomeScreenItems = [
  // const Text('Notifications'),
  const HomeScreen(),
  // const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('Notifications'),
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  //   // uid: uid,
  //   // uid: FirestoreMethods.user.uid,
  // ),
  ProfileScreen(
     uid: sharedPreferences.getString(keyShared.CURRENTUSER),
  ),
];
