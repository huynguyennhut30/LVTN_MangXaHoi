import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lvtn_mangxahoi/models/user.dart';
import 'package:lvtn_mangxahoi/provider/user_provider.dart';
import 'package:lvtn_mangxahoi/resources/auth_method.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/chat_detail_screen.dart';
import 'package:lvtn_mangxahoi/screens/detail_post_screen.dart';
import 'package:lvtn_mangxahoi/screens/login_screens.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/utils/utils.dart';
import 'package:lvtn_mangxahoi/widgets/background_home.dart';
import 'package:lvtn_mangxahoi/widgets/follow_button.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;
import '../widgets/stat.dart';
import 'profile_edit_screen.dart';
import 'package:lvtn_mangxahoi/utils/key_shared.dart';
import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';

// hiển thị màn hình hồ sơ người dùng
class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  // đc kế thừa
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTab = 'photos';

  _changeTab(String tab) {
    setState(() => _selectedTab = tab);
  }

  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  // khởi tạo
  void initState() {
    super.initState();
    getData(); // được gọi để lấy dữ liệu người dùng từ Firestore.
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = await userSnap.data()!;
      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid',
              isEqualTo: sharedPreferences.getString(keyShared.CURRENTUSER))
          .get();

      postLen = postSnap.docs.length;

      followers = await userSnap.data()!['followers'].length;
      following = await userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(sharedPreferences.getString(keyShared.CURRENTUSER));
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showFollowingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          title: const Text(
            'Đang theo dõi',
            style: TextStyle(color: kBlack),
          ),
          content: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('followers', arrayContains: userData['uid'])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text(
                  'Chưa có ai theo dõi bạn',
                  style: TextStyle(color: kBlack),
                ));
              } else {
                List<User> followers = snapshot.data!.docs
                    .map((doc) =>
                        User.fromJson(doc.data()! as Map<String, dynamic>))
                    .toList();
                return ListView.builder(
                  itemCount: followers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl'],
                        ),
                        radius: 16,
                      ),
                      title: Text(
                        followers[index].username,
                        style: const TextStyle(color: kBlack),
                      ),
                      onTap: () {
                        // Handle follower item tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(uid: followers[index].uid),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  void _showFollowersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhite,
          title: const Text(
            'Người theo dõi',
            style: TextStyle(color: kBlack),
          ),
          content: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('following', arrayContains: userData['uid'])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Bạn chưa theo dõi ai',
                    style: TextStyle(color: kBlack),
                  ),
                );
              } else {
                List<User> followers = snapshot.data!.docs
                    .map((doc) =>
                        User.fromJson(doc.data()! as Map<String, dynamic>))
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: followers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl'],
                        ),
                        radius: 16,
                      ),
                      title: Text(
                        followers[index].username,
                        style: const TextStyle(color: kBlack),
                      ),
                      onTap: () {
                        // Handle follower item tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(uid: followers[index].uid),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User userS = User.fromJson(userData.cast());
  //  DocumentSnapshot snap = FirebaseFirestore
  //       .instance
  //       .collection('users')
  //       .where(widget.uid)
  //       .snapshots() as DocumentSnapshot<Object?> ;
  //   User userS = User.fromJson(snap as Map<String, dynamic>);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : BackgroungHome(
            child: Scaffold(
              backgroundColor:
                  sharedPreferences.getString(keyShared.CURRENTUSER) ==
                          widget.uid
                      ? Colors.transparent
                      : Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 120.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return profileEditScreen(
                                                    userData: userData,
                                                  );
                                                },
                                              ));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 0.1))),
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              alignment: Alignment.centerLeft,
                                              height: 60,
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 17,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("Thông tin cá nhân"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await aut.signOut();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreens(),
                                                  ));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              alignment: Alignment.centerLeft,
                                              height: 60,
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.logout,
                                                    color: Colors.white,
                                                    size: 17,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("Đăng xuất"),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: sharedPreferences
                                          .getString(keyShared.CURRENTUSER) ==
                                      widget.uid
                                  ? Container(
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: const Icon(
                                        Icons.pending,
                                        color:
                                            Color.fromARGB(255, 181, 176, 176),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ),
                          Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 140.0,
                              height: 140.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0, color: kBlack),
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: ProfileImageClipper(),
                            child: Image.network(
                              userData['photoUrl'],
                              width: 180.0,
                              height: 180.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(userData['username'],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25)),
                    const SizedBox(height: 4.0),
                    Text(userData['email'],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15)),
                    sharedPreferences.getString(keyShared.CURRENTUSER) ==
                            widget.uid
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isFollowing
                                  ? FollowButton(
                                      text: 'Hủy theo dõi',
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                      function: () async {
                                        await FireStoreMethods().followUser(
                                          sharedPreferences
                                              .getString(keyShared.CURRENTUSER),
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    )
                                  : FollowButton(
                                      text: 'Theo dõi',
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                      function: () async {
                                        await FireStoreMethods().followUser(
                                          sharedPreferences
                                              .getString(keyShared.CURRENTUSER),
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    ),
                              FollowButton(
                                backgroundColor: Colors.grey,
                                borderColor: Colors.grey,
                                text: ' Nhắn tin',
                                textColor: kBlack,
                                function: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailScreen(
                                          user: userS,
                                        ),
                                      ));
                                },
                              ),
                            ],
                          ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stat(title: 'Bài viết', value: postLen),
                          InkWell(
                            child:
                                Stat(title: 'Người theo dõi', value: followers),
                            onTap: () => _showFollowersDialog(context),
                          ),
                          InkWell(
                            child:
                                Stat(title: 'Đang theo dõi', value: following),
                            onTap: () => _showFollowingsDialog(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => _changeTab('photos'),
                          child: SvgPicture.asset(
                            'assets/Button-photos.svg',
                            height: 20,
                            color: _selectedTab == 'photos'
                                ? k2AccentStroke
                                : null,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _changeTab('saved'),
                          child: SvgPicture.asset(
                            'assets/Button-saved.svg',
                            height: 20,
                            color:
                                _selectedTab == 'saved' ? k2AccentStroke : null,
                          ),
                        ),
                      ],
                    ),
                    _selectedTab == "photos"
                        ? FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: widget.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];

                                  return InkWell(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return detailPost(
                                            snap: snap,
                                            idpost: snap['postId'],
                                          );
                                        },
                                      ));
                                    },
                                    child: Container(
                                      child: Image(
                                        image: NetworkImage(snap['postUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('saves', arrayContains: widget.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return detailPost(
                                            snap: snap,
                                            idpost: snap['postId'],
                                          );
                                        },
                                      ));
                                    },
                                    child: Container(
                                      child: Image(
                                        image: NetworkImage(snap['postUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
          );
  }
}

class ProfileImageClipper extends CustomClipper<Path> {
  double radius = 35;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width / 2 - radius, radius)
      ..quadraticBezierTo(size.width / 2, 0, size.width / 2 + radius, radius)
      ..lineTo(size.width - radius, size.height / 2 - radius)
      ..quadraticBezierTo(size.width, size.height / 2, size.width - radius,
          size.height / 2 + radius)
      ..lineTo(size.width / 2 + radius, size.height - radius)
      ..quadraticBezierTo(size.width / 2, size.height, size.width / 2 - radius,
          size.height - radius)
      ..lineTo(radius, size.height / 2 + radius)
      ..quadraticBezierTo(0, size.height / 2, radius, size.height / 2 - radius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
