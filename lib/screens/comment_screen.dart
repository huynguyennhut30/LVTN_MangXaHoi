import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lvtn_mangxahoi/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart';
import '../models/user.dart';
import '../resources/firestore_methods.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
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
            child: Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            )),
        title: Text(
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
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: txtedit,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  decoration: InputDecoration(
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
                  fireMethod.addComment(cmt);
                  txtedit.text = "";
                },
                child: Text(
                  "Đăng",
                  style: TextStyle(
                      color: const Color.fromARGB(196, 158, 158, 158)),
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
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 4,
            ),
            Text(DateFormat('hh:mm a').format(ds['datePublished'].toDate()),
                style: TextStyle(
                    fontSize: 8, color: Color.fromARGB(255, 146, 139, 139))),
          ],
        ),
        subtitle: Text(
          ds['content'],
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
