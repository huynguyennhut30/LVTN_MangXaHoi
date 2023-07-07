import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lvtn_mangxahoi/models/user.dart' as model;
import 'package:lvtn_mangxahoi/resources/storage_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lvtn_mangxahoi/utils/key_shared.dart';
import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePic', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          createdAt: '',
          isOnline: false,
          lastActive: '',
          pushToken: '',
          followers: [],
          following: [],
          titleUser: [],
        );

        await _firestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );

        // await _firestore.collection("users").add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });
        res = "success";
        String a = await _auth.currentUser!.uid;
        sharedPreferences.setString(keyShared.CURRENTUSER, a);
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The Email is not formatted correctly';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
        String a = await _auth.currentUser!.uid;
        sharedPreferences.setString(keyShared.CURRENTUSER, a);
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    // await DefaultCacheManager().emptyCache();
    // await DefaultCacheManager().emptyCache();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await _auth.signOut();
  }
}

Future<void> clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

AuthMethod aut = AuthMethod();
