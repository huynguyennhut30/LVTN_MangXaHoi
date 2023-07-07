import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class notification {
  final String noId;
  final String uid_action;
  final String uid_action_image;
  final String uid_action_name;
  final String uid_recei;
  final String postId;
  final String content;
  final DateTime created_at;
  notification({
    required this.uid_action_image,
    required this.uid_action_name,
    required this.noId,
    required this.uid_action,
    required this.uid_recei,
    required this.content,
    required this.created_at,
    required this.postId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noId': noId,
      'uid_action': uid_action,
      'uid_recei': uid_recei,
      'content': content,
      'created_at': created_at,
    };
  }

  factory notification.fromMap(Map<String, dynamic> map) {
    return notification(
      noId: map['noId'] ?? "",
      uid_action: map['uid_action'] ?? "",
      uid_recei: map['uid_recei'] ?? "",
      content: map['content'] ?? "",
      created_at: map['created_at'] ?? DateTime.now(),
      uid_action_image: map['uid_action_image'] ?? "",
      uid_action_name: map['uid_action_name'] ?? "",
      postId: map['postId'] ?? "",
    );
  }
}
