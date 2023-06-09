

// class FirestoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Future<String> uploadPost(String description, Uint8List file, String uid,
//       String username, String profImage) async {
//     String res = "Some error";
//     try {
//       String photoUrl =
//           await StorageMethods().uploadImageToStorage('posts', file, true);
//       String postId = const Uuid().v1();
//       Post post = Post(
//           description: description,
//           uid: uid,
//           username: username,
//           saves: [],
//           likes: [],
//           postId: postId,
//           datePublished: DateTime.now(),
//           postUrl: photoUrl,
//           profImage: profImage);
//       _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }
  
//   Future<String> updateInforUser({Uint8List? file,String? id,String? username,String? bio})async {
//     try{
//       late String photoUrl="";
//       if(file!=null){
//           photoUrl = await StorageMethods().uploadImageToStorage('profilePic', file, true);
//       }
      
//       Map<String,dynamic> data = Map();
//       if(username!.isNotEmpty){
//         data['username']= username;
//       }
//       if(bio!.isNotEmpty){
//         data['bio']= bio;
//       }
//        if(photoUrl!=""){
//         data['photoUrl'] = photoUrl;
//       }
      
//       _firestore.collection("users").doc(id).get().then(
//         (value){
//           if(value.exists){
            
//             return _firestore.collection("users").doc(id).update(
//               data
//             );
//           }else {
//             return "dont found";
//           }
//         }
//       );
//     }catch(e){
//       print(e);
//     }
//     return "";
//   } 
  
//   Future<String> userLikePost({ String? id ,String? idpost})async {
   
//     try{
//       //tim user haved like post
//        final a =  await _firestore.collection("posts").doc(idpost).get();
//      Map<String,dynamic>? map = a.data();
//      for (var element in List.from(map!['likes'])) {
//        if(id==element){
//         //delete elemet 
//           _firestore.collection("posts").doc(idpost).get().then(
//         (value){
//           if(value.exists){
            
//             return _firestore.collection("posts").doc(idpost).update(
//               {
//                 "likes": FieldValue.arrayRemove([id])
//               }
//             );
//           }else {
//             return "dont found";
//           }
//         }
//       );
//           return "unlike";
//        }
//      }
//      //like
//       _firestore.collection("posts").doc(idpost).get().then(
//         (value){
//           if(value.exists){
            
//             return _firestore.collection("posts").doc(idpost).update(
//               {
//                 "likes": FieldValue.arrayUnion([id])
//               }
//             );
//           }else {
//             return "dont found";
//           }
//         }
//       );
//     }catch(e){
//       print(e);
//     }
//     return "";
//   }

  // Future<String> userSavePost({ String? id ,String? idpost})async {
  //   try{
  //     //tim user haved like post
  //      final a =  await _firestore.collection("posts").doc(idpost).get();
  //    Map<String,dynamic>? map = a.data();
  //    for (var element in List.from(map!['saves'])) {
  //      if(id==element){
  //       //delete elemet 
  //         _firestore.collection("posts").doc(idpost).get().then(
  //       (value){
  //         if(value.exists){
            
  //           return _firestore.collection("posts").doc(idpost).update(
  //             {
  //               "saves": FieldValue.arrayRemove([id])
  //             }
  //           );
  //         }else {
  //           return "dont found";
  //         }
  //       }
  //     );
  //         return "unsave";
  //      }
  //    }
  //    //save
  //     _firestore.collection("posts").doc(idpost).get().then(
  //       (value){
  //         if(value.exists){
            
  //           return _firestore.collection("posts").doc(idpost).update(
  //             {
  //               "saves": FieldValue.arrayUnion([id])
  //             }
  //           );
  //         }else {
  //           return "dont found";
  //         }
  //       }
  //     );
  //   }catch(e){
  //     print(e);
  //   }
  //   return "";
  // } 
  
//   Future<dynamic> checUserLiked({ String? id ,String? idpost})async {
     
//     try{
//      final a =  await _firestore.collection("posts").doc(idpost).get();
//      Map<String,dynamic>? map = a.data();
//      for (var element in List.from(map!['likes'])) {
//        if(id==element){
//         return true;
//        }
//      }
//     }catch(e){
//       return e;
//     }
//     return false;
//   }
//   Future<dynamic> checUserSaved({ String? id ,String? idpost})async {
     
//     try{
//      final a =  await _firestore.collection("posts").doc(idpost).get();
//      Map<String,dynamic>? map = a.data();
//      for (var element in List.from(map!['saves'])) {
//        if(id==element){
//         return true;
//        }
//      }
//     }catch(e){
//       return false;
//     }
//     return false;
//   }
//   Future<dynamic> addComment(comment cmt) async {
     
//     try{
//       await  _firestore.collection("comments").doc(cmt.commentId).set(cmt.toMap());
//     }catch(e){
//       return e;
//     }
//     return false;
//   }
//   Future<dynamic> countComment(String idpost) async {
     
//     try{
//      QuerySnapshot result =  await  _firestore.collection("comments").where("postId",isEqualTo: idpost).get();
//      return result;
//     }catch(e){
//       return 0;
//     }
   
//   }
// }

// FirestoreMethods fireMethod = new FirestoreMethods();





// class FirestoreMethods {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   Future<String> uploadPost(String description, Uint8List file, String uid,
//       String username, String profImage) async {
//     String res = "Some error";
//     try {
//       String photoUrl =
//           await StorageMethods().uploadImageToStorage('posts', file, true);
//       String postId = const Uuid().v1();
//       Post post = Post(
//           description: description,
//           uid: uid,
//           username: username,
//           likes: [],
//           postId: postId,
//           datePublished: DateTime.now(),
//           postUrl: photoUrl,
//           profImage: profImage);
//       _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }
//   Future<String> updateInforUser(
//       {Uint8List? file, String? id, String? username, String? bio}) async {
//     try {
//       late String photoUrl = "";
//       if (file != null) {
//         photoUrl = await StorageMethods()
//             .uploadImageToStorage('profilePic', file, true);
//       }
//       Map<String, dynamic> data = Map();
//       if (username!.isNotEmpty) {
//         data['username'] = username;
//       }
//       if (bio!.isNotEmpty) {
//         data['bio'] = bio;
//       }
//       if (photoUrl != "") {
//         data['photoUrl'] = photoUrl;
//       }
//       _firestore.collection("users").doc(id).get().then((value) {
//         if (value.exists) {
//           return _firestore.collection("users").doc(id).update(data);
//         } else {
//           return "dont found";
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//     return "";
//   }
// }
// FirestoreMethods fireMethod = new FirestoreMethods();
