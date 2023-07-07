import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/comment_screen.dart';
import 'package:lvtn_mangxahoi/screens/profile_screen.dart';

class detailPost extends StatefulWidget {
  final snap;
  final String idpost;
  const detailPost({super.key, this.snap, required this.idpost});

  @override
  State<detailPost> createState() => _detailPostState();
}

class _detailPostState extends State<detailPost> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool _checkLike = false;
  bool _checkSave = false;

  void getResultLiked() async {
    bool data = await fireMethod.checUserLiked(
        id: FirebaseAuth.instance.currentUser!.uid, idpost: widget.idpost);
    bool dataSave = await fireMethod.checUserSaved(
        id: FirebaseAuth.instance.currentUser!.uid, idpost: widget.idpost);

    setState(() {
      _checkLike = data;
      _checkSave = dataSave;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResultLiked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Bài viết",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(uid: widget.snap['uid']),
                      ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.snap['profImage']),
                      maxRadius: 16.0,
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 146, 145, 145)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.snap['description'],
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.snap['postUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // const Divider(
            //   color: Colors.black,
            //   height: 1,
            // ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 50,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              widget.snap['likes'].length.toString(), //widged text
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ), //sửa style cho chữ và kích cỡ
            ),
            _checkLike //tạo điều kiện xem đã like hay chưa
                ? IconButton(
                    onPressed: () async {
                      fireMethod.userLikePost(
                          id: FirebaseAuth.instance.currentUser!
                              .uid, //id được lấy từ firebaseauth
                          idpost: widget.idpost); //idpost lấy ở trên widget
                      setState(() {
                        _checkLike = false;
                      });
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 206, 103, 95),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      fireMethod.userLikePost(
                          id: FirebaseAuth.instance.currentUser!.uid,
                          idpost: widget.idpost);
                      setState(() {
                        _checkLike = true;
                      });
                    },
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                    ),
                  ),
            StreamBuilder(
              //dùng stream builder để hiện thị cập nhật dữ liệu cmt liên tục
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .where("postId", isEqualTo: widget.idpost)
                  .snapshots(), //trả về querysnapshot
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //loading khi đang lấy dữ liệu
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Text(
                  snapshot.data!.docs.length.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => commentScreen(
                          postId: widget.snap['postId'],
                          uidPost: widget.snap['uid']),
                    ));
              },
              icon: const Icon(
                Icons.comment_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: _checkSave ==
                        false //kiểm trả xem hiện tại đã ấn save hay chưa
                    ? IconButton(
                        onPressed: () {
                          fireMethod.userSavePost(
                              id: FirebaseAuth.instance.currentUser!.uid,
                              idpost: widget.idpost);
                          setState(() {
                            _checkSave = true;
                          });
                        },
                        icon: const Icon(
                          Icons.bookmark_border,
                          color: Colors.black,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          fireMethod.userSavePost(
                              id: FirebaseAuth.instance.currentUser!.uid,
                              idpost: widget.idpost);
                          setState(() {
                            _checkSave = false;
                          });
                        },
                        icon: const Icon(
                          Icons.bookmark_rounded,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
