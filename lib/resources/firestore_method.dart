import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lvtn_mangxahoi/models/post.dart';
import 'package:uuid/uuid.dart';

import 'storage_method.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<String> updateInforUser({Uint8List? file,String? id,String? username,String? bio})async {
    try{
      late String photoUrl="";
      if(file!=null){
          photoUrl = await StorageMethods().uploadImageToStorage('profilePic', file, true);
      }
      
      Map<String,dynamic> data = Map();
      if(username!.isNotEmpty){
        data['username']= username;
      }
      if(bio!.isNotEmpty){
        data['bio']= bio;
      }
       if(photoUrl!=""){
        data['photoUrl'] = photoUrl;
      }
      
      _firestore.collection("users").doc(id).get().then(
        (value){
          if(value.exists){
            
            return _firestore.collection("users").doc(id).update(
              data
            );
          }else {
            return "dont found";
          }
        }
      );
    }catch(e){
      print(e);
    }
    return "";
  } 
}
FirestoreMethods fireMethod = new FirestoreMethods();