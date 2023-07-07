import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lvtn_mangxahoi/models/user.dart' as model;
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/comment_screen.dart';
import 'package:lvtn_mangxahoi/screens/detail_post_screen.dart';
import 'package:lvtn_mangxahoi/screens/profile_screen.dart';
import 'package:lvtn_mangxahoi/screens/report_screen.dart';
import 'package:lvtn_mangxahoi/utils/key_shared.dart';
import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utils/colors.dart';

class PostCard extends StatefulWidget {
  final snap;
  final String idpost;
  const PostCard({super.key, this.snap, required this.idpost});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool _checkLike = false;
  bool _checkSave = false;

  @override
  void initState() {
    super.initState();
    getResultLiked();
  }

  void getResultLiked() async {
    bool data = await fireMethod.checUserLiked(
        id: sharedPreferences.getString(keyShared.CURRENTUSER),
        idpost: widget.idpost);
    bool dataSave = await fireMethod.checUserSaved(
        id: sharedPreferences.getString(keyShared.CURRENTUSER),
        idpost: widget.idpost);

    setState(() {
      _checkLike = data;
      _checkSave = dataSave;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return detailPost(
              snap: widget.snap,
              idpost: widget.idpost,
            );
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 14.0,
        ),
        padding: const EdgeInsets.all(14.0),
        height: size.height * 0.40,
        width: size.width,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: NetworkImage(widget.snap['postUrl']),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          uid: widget.snap['uid'],
                        ),
                      ),
                    );
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
                                .copyWith(color: kWhite),
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(widget.snap['datePublished'].toDate()),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: const Color(0xFFD8D8D8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.more_vert, color: kWhite),
                // ),
                PopupMenuTheme(
                  data: PopupMenuThemeData(
                    color: Colors.grey[100],
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (String result) {
                      // Xử lý sự kiện khi người dùng chọn một lựa chọn trong danh sách
                      switch (result) {
                        case 'option1':
                          // Thực hiện hành động của lựa chọn 1
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportScreen(
                                postId: widget.snap['postId'],
                                postUrl: widget.snap['postUrl'],
                              ),
                            ),
                          );
                          break;
                        // Thêm các lựa chọn khác ở đây
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'option1',
                        child: Text(
                          'Báo cáo',
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      // Thêm các PopupMenuItem khác ở đây
                    ],
                    // child: IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.more_vert, color: kWhite),
                    // ),
                  ),
                )
              ],
            ),
            const Spacer(),
            // thả tim
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.snap['likes'].length.toString(), //widged text
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w700), //sửa style cho chữ và kích cỡ
                ),
                _checkLike //tạo điều kiện xem đã like hay chưa
                    ? IconButton(
                        onPressed: () async {
                          fireMethod.userLikePost(
                              id: sharedPreferences.getString(keyShared
                                  .CURRENTUSER), //id được lấy từ firebaseauth
                              idpost: widget.idpost); //idpost lấy ở trên widget
                          setState(() {
                            _checkLike = false;
                          });
                          // getResultLiked();
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 206, 103, 95),
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          fireMethod.userLikePost(
                              id: sharedPreferences
                                  .getString(keyShared.CURRENTUSER),
                              idpost: widget.idpost,
                              idUserPost: widget.snap['uid']);
                          setState(() {
                            _checkLike = true;
                          });
                          // getResultLiked();
                        },
                        icon: Icon(
                          Icons.favorite_border_outlined,
                        ),
                      ),
                StreamBuilder(
                  //dùng stream builder để hiện thị cập nhật dữ liệu cmt liên tục
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .where("postId", isEqualTo: widget.idpost)
                      .snapshots(), //trả về querysnapshot
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //loading khi đang lấy dữ liệu
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Text(
                      snapshot.data!.docs.length.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
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
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
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
                                  id: sharedPreferences
                                      .getString(keyShared.CURRENTUSER),
                                  idpost: widget.idpost);
                              setState(() {
                                _checkSave = true;
                              });
                            },
                            icon: const Icon(
                              Icons.bookmark_border,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              fireMethod.userSavePost(
                                  id: sharedPreferences
                                      .getString(keyShared.CURRENTUSER),
                                  idpost: widget.idpost);
                              setState(() {
                                _checkSave = false;
                              });
                            },
                            icon: const Icon(
                              Icons.bookmark_rounded,
                            ),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _buildPostStat({
    required BuildContext context,
    required Icon iconPath,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5).withOpacity(0.40),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Row(
        children: [
          // SvgPicture.asset(
          //   iconPath,
          //   color: kWhite,
          // ),
          const SizedBox(width: 8.0),
          Text(
            value,
            style:
                Theme.of(context).textTheme.labelSmall!.copyWith(color: kWhite),
          ),
        ],
      ),
    );
  }
}
