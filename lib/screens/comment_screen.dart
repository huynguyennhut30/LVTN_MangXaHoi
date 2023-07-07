import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lvtn_mangxahoi/models/comment.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:uuid/uuid.dart';

import 'package:lvtn_mangxahoi/models/user.dart';
import 'package:lvtn_mangxahoi/provider/user_provider.dart';
import 'package:provider/provider.dart';

class commentScreen extends StatefulWidget {
  final String postId;
  final String uidPost;
  const commentScreen({super.key, required this.postId, required this.uidPost});

  @override
  State<commentScreen> createState() => _commentScreenState();
}

class _commentScreenState extends State<commentScreen> {
  TextEditingController txtedit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            )),
        title: const Text(
          "Bình luận",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where("postId", isEqualTo: widget.postId)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return cardComment(
                      ds: snapshot.data!.docs[index].data(),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  controller: txtedit,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: "Thêm bình luận..",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  String commentId = const Uuid().v1();
                  Comment cmt = Comment(
                      datePublished: DateTime.now(),
                      commentId: commentId,
                      content: txtedit.text,
                      uid: user.uid,
                      uimage: user.photoUrl,
                      username: user.username,
                      postId: widget.postId);
                  fireMethod.addComment(cmt, widget.uidPost);
                  txtedit.text = "";
                },
                child: const Text(
                  "Đăng",
                  style: TextStyle(color: Colors.blueAccent),
                ))
          ],
        ),
      ),
    );
  }
}

class cardComment extends StatelessWidget {
  final ds;
  const cardComment({
    Key? key,
    required this.ds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(ds);
    return Container(
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          child: ClipOval(
            child: Image.network(ds['uimage']),
          ),
        ),
        title: Row(
          children: [
            Text(
              ds['username'],
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(DateFormat('hh:mm a').format(ds['datePublished'].toDate()),
                style: const TextStyle(
                    fontSize: 8, color: Color.fromARGB(255, 146, 139, 139))),
          ],
        ),
        subtitle: Text(
          ds['content'],
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
