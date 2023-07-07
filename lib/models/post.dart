import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  late String description;
  late String uid;
  late String username;
  late List likes;
  late List saves;
  late String postId;
  late DateTime datePublished;
  late String postUrl;
  late String profImage;
  late List titlePost;
  late String timestamp;

  Post({
    required this.saves,
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.titlePost,
    required this.timestamp,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        saves: snapshot['saves'],
        titlePost: snapshot['titlePost'],
        timestamp: 'timestamp');
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'saves': saves,
        'titlePost': titlePost,
        'timestamp': timestamp,
      };

  // factory Post.createDefault() {
  //   return Post(
  //     datePublished: DateTime.now(),
  //     description: '',
  //     likes: [],
  //     postId: '',
  //     postUrl: '',
  //     profImage: '',
  //     saves: [],
  //     uid: '',
  //     username: '',
  //     titlePost: [],
  //   );
  // }

  Post.fromJson(Map<String, dynamic> json) {
    datePublished = json['datePublished'] ?? '';
    saves = json['saves'] ?? [];
    description = json['description'] ?? '';
    uid = json['uid'] ?? '';
    postUrl = json['postUrl'] ?? '';
    username = json['username'] ?? '';
    likes = json['likes'] ?? [];
    profImage = json['profImage'] ?? '';
    postId = json['postId'] ?? '';
    titlePost = json['titlePost'] ?? [];
    timestamp = json['timestamp'] ?? [];
  }
}
