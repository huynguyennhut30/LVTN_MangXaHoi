import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String uid;
  late String email;
  late String photoUrl;
  late String username;
  late String bio;
  late String createdAt;
  late bool isOnline;
  late String lastActive;
  late List followers;
  late List following;
  late String pushToken;

  User(
      {required this.uid,
      required this.username,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.createdAt,
      required this.isOnline,
      required this.lastActive,
      required this.pushToken,
      required this.followers,
      required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    var user = User(
      uid: snapshot["uid"],
      username: snapshot["username"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      createdAt: snapshot["createdAt"],
      isOnline: snapshot["isOnline"],
      lastActive: snapshot["lastActive"],
      pushToken: snapshot["pushToken"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
    return user;
  }

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'] ?? '';
    uid = json['uid'] ?? '';
    photoUrl = json['photoUrl'] ?? '';
    username = json['username'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_Token'] ?? '';
    bio = json['bio'] ?? '';
    followers = json['followers'] ?? '';
    following = json['following'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "createdAt": createdAt,
        "isOnline": isOnline,
        "lastActive": lastActive,
        "pushToken": pushToken,
        "followers": followers,
        "following": following,
      };
  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['image'] = photoUrl;
  //   data['bio'] = bio;
  //   data['name'] = username;
  //   data['created_at'] = createdAt;
  //   data['is_online'] = isOnline;
  //   data['uid'] = uid;
  //   data['followers'] = followers;
  //   data['following'] = following;
  //   data['last_active'] = lastActive;
  //   data['email'] = email;
  //   data['push_token'] = pushToken;
  //   return data;
  // }
}
