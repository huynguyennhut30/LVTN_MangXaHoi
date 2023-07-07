import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart';
import 'package:lvtn_mangxahoi/models/notification.dart';

import 'package:lvtn_mangxahoi/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart';
import '../models/message.dart';
import '../models/post.dart';
import '../models/user.dart';

class FireStoreMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static auth.FirebaseAuth Auth = auth.FirebaseAuth.instance;

  // static User me = User(
  //     uid: user.uid,
  //     username: user.displayName.toString(),
  //     photoUrl: user.photoURL.toString(),
  //     email: user.email.toString(),
  //     bio: '',
  //     createdAt: '',
  //     isOnline: false,
  //     lastActive: '',
  //     pushToken: '',
  //     followers: [],
  //     following: [],
  //     lastMessageTime: []);

  // static  User me = User.createDefault(user as User);
  static late User me;

  static late Message mess;

  static auth.User get user => Auth.currentUser!;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> readPosts(int postCount) {
    StreamController<QuerySnapshot<Map<String, dynamic>>> streamController =
        StreamController<QuerySnapshot<Map<String, dynamic>>>();
    firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> userSnapshot) async {
      List<String> userTopics = [];
      if (userSnapshot.exists && userSnapshot.data() != null) {
        List<dynamic> arrayData =
            (userSnapshot.data() as dynamic)['following'].toList();
        if (arrayData != null && arrayData is List<dynamic>) {
          userTopics = List<String>.from(arrayData);
        }
      }
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('posts')
          .where('uid', whereIn: userTopics)
          // .orderBy('timestamp', descending: true)
          .limit(postCount)
          .get();
      // Thêm kết quả truy vấn vào Stream
      streamController.add(querySnapshot);
    });

    return streamController.stream;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    // List<String> followedUsers = [];
    List<String> userTopics = [];

    StreamController<QuerySnapshot<Map<String, dynamic>>> streamController =
        StreamController<QuerySnapshot<Map<String, dynamic>>>();
    firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> userSnapshot) async {
      // List<String> userTopics = [];
      if (userSnapshot.exists && userSnapshot.data() != null) {
        List<dynamic> arrayData =
            (userSnapshot.data() as dynamic)['following'].toList();
        if (arrayData != null && arrayData is List<dynamic>) {
          userTopics = List<String>.from(arrayData);
        }
      }
      // QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
      //     .collection('users')
      //     .where('uid', whereIn: userTopics)
      //     .orderBy('createdAt', descending: true)
      //     .get();
      // // Thêm kết quả truy vấn vào Stream
      // streamController.add(querySnapshot);
    });
    return firestore
        .collection('users')
        .where('uid', whereIn: me.following)
        .orderBy('createdAt', descending: true)
        .snapshots();
    // return streamController.stream;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>? readPost() {
    if (me.following.isNotEmpty) {
      return firestore
          .collection('posts')
          .where('uid', whereIn: me.following)
          .snapshots();
    } else {
      return null;
      // return firestore
      //     .collection('posts')
      //     .snapshots();
    }

    // return firestore
    //     .collection('posts')
    //     .where('uid', whereIn: me.following)
    //     .snapshots();

    // final myDocRef  = firestore.collection('users').doc(user.uid).snapshots();
    // myDocRef
    // final myDocSnapshot = myDocRef.get();
    // final myArray = List<String>.from(myDocSnapshot.data()!['myArray']);
    // List<dynamic> myArray = myDocRef.data()!['myArray'];
    // List<String> followingList = [];
    // StreamSubscription<DocumentSnapshot> myDocRef =
    //     firestore.collection('users').doc(user.uid).snapshots().listen((event) {
    //   Map<String, dynamic> myMap = event.data()
    //       as Map<String, dynamic>; // truy cập vào data() để lấy dữ liệu
    //   followingList = List<String>.from(myMap['following']);
    // });
    // List<String> followingList = List<String>.from(myMap['following']);

    // return firestore
    //     .collection('posts')
    //     .where('uid', whereIn: followingList)
    //     .snapshots();
  }

//   static Future<bool> getTitlePost() async {
//     // lấy danh sách chủ đề của user
//     final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
//     final userDoc = await userRef.get();
//     final userTopics = userDoc.get('titleUser');

// // lấy danh sách chủ đề của post
//     final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
//     final postDoc = await postRef.get();
//     final postTopics = postDoc.get('topics');

// // kiểm tra xem có phần tử nào trong mảng chủ đề của user trùng khớp với mảng chủ đề của post hay không
//     for (var userTopic in userTopics) {
//       if (postTopics.contains(userTopic)) {
//         // nếu có ít nhất một phần tử trùng khớp, trả về kết quả tương ứng
//         return true;
//       }
//     }

// // nếu không có phần tử trùng khớp, trả về false
//     return false;
//   }

  static Future<void> uploadTitle(List<String> selectedTopics) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'titleUser': selectedTopics});
  }

  static Future<List<String>> getList() async {
    List<String> fl = [];
    DocumentSnapshot myDocRef =
        await firestore.collection('users').doc(user.uid).get();
    if (myDocRef.exists) {
      // List<dynamic> myArray = myDocRef.data()!['following'];
      Map<String, dynamic> myMap = myDocRef as Map<String, dynamic>;
      // List value = myMap['following'];
      List<String> followingList = List<String>.from(myMap['following']);
      if (followingList != null) {
        for (var item in followingList) {
          fl.add(item);
        }
      }
    }
    return fl;
  }

  // Khi muốn load thêm bài đăng, bạn có thể sử dụng phương thức này
  static Future<void> loadMorePosts(
      QuerySnapshot<Map<String, dynamic>> snapshot, int limit) async {
    if (snapshot.docs.length < limit) {
      // Nếu không còn bài đăng để load, thoát hàm
      return;
    }
    DocumentSnapshot lastDocument = snapshot.docs[snapshot.docs.length - 1];
    CollectionReference postsRef = firestore.collection('posts');
    Query query = postsRef
        .where('uid', whereIn: me.following)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit);
    QuerySnapshot<Object?> newSnapshot = await query.get();
    // Xử lý danh sách bài đăng mới ở đây
    // ...
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatList() {
    Stream<QuerySnapshot<Map<String, dynamic>>> userList =
        firestore.collection('users').snapshots();
    Stream<QuerySnapshot<Map<String, dynamic>>> userMesList = firestore
        .collection('chats')
        .doc(user.uid)
        .collection('userList')
        .snapshots();

    return firestore.collection('chats/${user.uid}/userList/').snapshots();

    // return firestore
    //     .collection('chats')
    //     .doc(user.uid)
    //     .collection('userList')
    //     .snapshots();

    // return firestore
    //     .collection('users')
    //     .where('uid', whereIn: me.following)
    //     .snapshots()
    //     .asyncMap((querySnapshot) async {
    //   List<Message> messages = [];
    //   Message? mes ;
    //   for (DocumentSnapshot userSnapshot in querySnapshot.docs) {
    //     String sent = userSnapshot['sent'];
    //     DocumentSnapshot messSnaphot = await firestore
    //         .collection('chats/${getConversationID(user.uid)}/messages/')
    //         .doc(sent)
    //         .get();
    //         messages.add(mes!.getSent);
    //   }
    //   return messages;
    // });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChat() {
    // List<String> followedUsers = [];
    return firestore
        .collection('users')
        .where('uid', whereIn: me.following)
        .snapshots();
  }

  // firestore.collection('users').doc(user.uid).collection('following').get().then(QuerySnapshot snapshot {
  //   snapshot.docs.forEach((doc) {
  //         followingList.add(doc.id);
  //     })
  // });

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      User chatUser) {
    return firestore
        .collection('users')
        .where('uid', isEqualTo: chatUser.uid)
        .snapshots();
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = User.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        FireStoreMethods.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      }
      // else {
      //   await createUser().then((value) => getSelfInfo());
      // }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserChat() {
    return firestore.collection('usres').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('uid',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChat(User chatUser) {
    return firestore
        .collection('messages')
        .doc(user.uid)
        .collection(chatUser.uid)
        .snapshots();
  }

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print('Push Token: $t');
      }
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      User chatUser) {
    return firestore
        .collection('chats/${getConversationID(chatUser.uid)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(User chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
      toId: chatUser.uid,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
    );

    // final User us = User(
    //   uid: chatUser.uid,
    //   username: chatUser.username,
    //   photoUrl: chatUser.photoUrl,
    //   email: chatUser.email,
    //   bio: chatUser.bio,
    //   createdAt: chatUser.createdAt,
    //   isOnline: chatUser.isOnline,
    //   lastActive: chatUser.lastActive,
    //   pushToken: chatUser.pushToken,
    //   followers: chatUser.followers,
    //   following: chatUser.following,
    // );

    await firestore
        .collection('users')
        .doc(chatUser.uid)
        .update({'createdAt': time});
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.uid)}/messages/');
    await ref.doc(time).set(message.toJson());

    // final ref =
    //     firestore.collection('chats/${user.uid}/messages/${chatUser.uid}');
    // await ref.doc(time).set(message.toJson());

    // final refUser =
    //     firestore.collection('chats').doc(user.uid).collection('userList');
    // await refUser.doc(chatUser.uid).set(us.toJson());
    // await refUser
    //     .doc(chatUser.uid)
    //     .collection('messList')
    //     .doc(time)
    //     .set(message.toJson());

    // await firestore
    //     .collection('messages')
    //     .doc(user.uid)
    //     .collection(chatUser.uid)
    //     .add({
    //   'toId': chatUser.uid,
    //   'msg': msg,
    //   'read': '',
    //   'type': type,
    //   'fromId': user.uid,
    //   'sent': time
    // });
    // await firestore
    //     .collection(chatUser.uid)
    //     .doc(chatUser.uid)
    //     .collection('msgList')
    //     .doc(time)
    //     .set(message.toJson());
  }

  static Future<void> sendFirstMessage(
      User chatUser, String msg, Type type) async {
    await firestore.collection('users').doc(chatUser.uid).set({}).then(
      (value) => sendMessage(chatUser, msg, type),
    );
  }

  // static Future<void> sendChat(User chatUser, String msg, Types type) async {
  //   //message sending time (also used as id)
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();
  //   //message to send
  //   final Chat message = Chat(
  //       toId: chatUser.uid,
  //       msg: msg,
  //       read: '',
  //       type: type,
  //       fromId: user.uid,
  //       sent: time);
  //   // final ref = firestore
  //   //     .collection('chats/${getConversationID(chatUser.uid)}/messages/');
  //   // await ref.doc(time).set(message.toJson()).then((value) =>
  //   //     sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  //   await firestore
  //       .collection('messages')
  //       .doc(user.uid)
  //       .collection(chatUser.uid)
  //       .add({
  //     'toId': chatUser.uid,
  //     'msg': msg,
  //     'read': '',
  //     'type': type,
  //     'fromId': user.uid,
  //     'sent': time
  //   });
  //   await firestore
  //       .collection('messages/${user.uid}')
  //       .doc(chatUser.uid)
  //       .collection('msgList')
  //       .doc(time)
  //       .set(message.toJson());
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(User user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(User chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = StorageMethods.storage.ref().child(
        'images/${getConversationID(chatUser.uid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

//**************MOI THEM***************** */
  // for sending push notification
  static Future<void> sendPushNotification(User chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.username, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAwVnKJcw:APA91bFg5ValCI0f2f5DpOKcADnb-IsHxAW2I10matKrAti3kpUHd94QoArHI_oq85-LYDFuNvlu8omo8UM7_k_FI0E6UZlLMnzB6w5KBR5EnGAOppjMXDhD1izisR_1XXvCt0oIXdbI'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getPostsByUserTopics() async {
    // Lấy danh sách chủ đề của người dùng hiện tại
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    List<String> userTopics = [];
    // List<String> userTopics = (userSnapshot.data() as dynamic)['titleUser'];
    if (userSnapshot.exists && userSnapshot.data() != null) {
      List<dynamic> arrayData =
          (userSnapshot.data() as dynamic)['titleUser'].toList();
      if (arrayData != null && arrayData is List<dynamic>) {
        userTopics = List<String>.from(arrayData);
      }
    }

    // Truy vấn các bài post có chủ đề trùng khớp với danh sách chủ đề của người dùng
    // QuerySnapshot postSnapshot = await FirebaseFirestore.instance
    //     .collection('posts')
    //     .where('titlePost', arrayContainsAny: userTopics)
    //     .get();
    // QuerySnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore
    //     .instance
    //     .collection('posts')
    //     .where('titlePost', arrayContainsAny: userTopics)
    //     .get();

    /************************** */
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('posts');
    if (userTopics.isNotEmpty) {
      query = query.where('titlePost', arrayContainsAny: userTopics);
    }
    QuerySnapshot<Map<String, dynamic>> postSnapshot = await query.get();

    // Lấy danh sách các bài post
    List<DocumentSnapshot> posts = postSnapshot.docs;

    // return posts;
    return postSnapshot;
  }

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage, List titlePost) async {
    String res = "Some error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        saves: [],
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        titlePost: titlePost,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateInforUser(
      {Uint8List? file, String? id, String? username, String? bio}) async {
    try {
      late String photoUrl = "";
      if (file != null) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePic', file, true);
      }

      Map<String, dynamic> data = Map();
      if (username!.isNotEmpty) {
        data['username'] = username;
      }
      if (bio!.isNotEmpty) {
        data['bio'] = bio;
      }
      if (photoUrl != "") {
        data['photoUrl'] = photoUrl;
      }

      firestore.collection("users").doc(id).get().then((value) {
        if (value.exists) {
          return firestore.collection("users").doc(id).update(data);
        } else {
          return "dont found";
        }
      });
      // firestore
      //     .collection('posts')
      //     .where('uid', isEqualTo: id).get().then((value) {
      //       {'profImage': photoUrl}
      //     });
      QuerySnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore
          .instance
          .collection('posts')
          .where('uid', isEqualTo: id)
          .get();

      for (DocumentSnapshot<Map<String, dynamic>> postDoc
          in postSnapshot.docs) {
        await postDoc.reference.update({'profImage': photoUrl});
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });

        final add =
            firestore.collection('users').doc(uid).collection('followingList');
        await add.doc(followId);
      } else {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> getUserName(String id) async {
    final a = await firestore.collection('users').doc(user.uid).get();

    Map<String, dynamic>? map = a.data();
    return map!['username'];
  }

  Future<String?> getUserImage(String id) async {
    final a = await firestore.collection('users').doc(user.uid).get();

    Map<String, dynamic>? map = a.data();
    return map!['photoUrl'];
  }

  Future<String> userLikePost(
      {String? id, String? idpost, String? idUserPost}) async {
    try {
      //tim user haved like post
      final a = await firestore.collection("posts").doc(idpost).get();
      Map<String, dynamic>? map = a.data();
      for (var element in List.from(map!['likes'])) {
        if (id == element) {
          //delete elemet
          firestore.collection("posts").doc(idpost).get().then((value) {
            if (value.exists) {
              return firestore.collection("posts").doc(idpost).update({
                "likes": FieldValue.arrayRemove([id])
              });
            } else {
              return "dont found";
            }
          });
          return "unlike";
        }
      }
      //like
      String? image = await getUserImage(user.uid);
      String? name = await getUserName(user.uid);
      String nofiD = const Uuid().v1();
      Map<String, dynamic> data = {
        "noId": nofiD,
        "uid_action": user.uid,
        "uid_recei": idUserPost,
        "uid_action_image": image,
        "uid_action_name": name,
        "content": "like",
        "created_at": DateTime.now(),
        "postId": idpost
      };
      await firestore.collection("notifications").doc(nofiD).set(data);
      firestore.collection("posts").doc(idpost).get().then((value) {
        if (value.exists) {
          return firestore.collection("posts").doc(idpost).update({
            "likes": FieldValue.arrayUnion([id])
          });
        } else {
          return "dont found";
        }
      });
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<dynamic> checUserLiked({String? id, String? idpost}) async {
    try {
      final a = await firestore.collection("posts").doc(idpost).get();
      Map<String, dynamic>? map = a.data();
      for (var element in List.from(map!['likes'])) {
        if (id == element) {
          return true;
        }
      }
    } catch (e) {
      return e;
    }
    return false;
  }

  Future<dynamic> checUserSaved({String? id, String? idpost}) async {
    try {
      final a = await firestore.collection("posts").doc(idpost).get();
      Map<String, dynamic>? map = a.data();
      for (var element in List.from(map!['saves'])) {
        if (id == element) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<dynamic> addComment(Comment cmt, String uidPost) async {
    try {
      await firestore
          .collection("comments")
          .doc(cmt.commentId)
          .set(cmt.toMap());
    } catch (e) {
      return e;
    }
    return false;
  }

  Future<dynamic> countComment(String idpost) async {
    try {
      QuerySnapshot result = await firestore
          .collection("comments")
          .where("postId", isEqualTo: idpost)
          .get();
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future<String> userSavePost({String? id, String? idpost}) async {
    try {
      //tim user haved like post
      final a = await firestore.collection("posts").doc(idpost).get();
      Map<String, dynamic>? map = a.data();
      for (var element in List.from(map!['saves'])) {
        if (id == element) {
          //delete elemet
          firestore.collection("posts").doc(idpost).get().then((value) {
            if (value.exists) {
              return firestore.collection("posts").doc(idpost).update({
                "saves": FieldValue.arrayRemove([id])
              });
            } else {
              return "dont found";
            }
          });
          return "unsave";
        }
      }
      //save
      firestore.collection("posts").doc(idpost).get().then((value) {
        if (value.exists) {
          return firestore.collection("posts").doc(idpost).update({
            "saves": FieldValue.arrayUnion([id])
          });
        } else {
          return "dont found";
        }
      });
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<dynamic> addNotificationn(notification nofi) async {
    // thêm comment
    try {
      await firestore
          .collection("notifications")
          .doc(nofi.noId)
          .set(nofi.toMap());
    } catch (e) {
      return e;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getPostByID(String id) async {
    final a = await firestore.collection('posts').doc(id).get();

    Map<String, dynamic>? map = a.data();
    return map;
  }

  static Future<void> addReport(
      String idPost, String description, String postUrl) async {
    String reportId = const Uuid().v1();
    await FirebaseFirestore.instance.collection('reports').add({
      'idReport':reportId,
      'idPost': idPost,
      'idUser': user.uid,
      'description': description,
      'photoUrlPost': postUrl,
      'time': Timestamp.now().millisecondsSinceEpoch.toString(),
    });
  }
}

FireStoreMethods fireMethod = new FireStoreMethods();
