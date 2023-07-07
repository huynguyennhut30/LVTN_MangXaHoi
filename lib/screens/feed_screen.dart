import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lvtn_mangxahoi/models/post.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/chat_screen.dart';
import 'package:lvtn_mangxahoi/screens/post_card.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/widgets/background_home.dart';

import '../utils/global_variables.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Post post;
  List<Post> _listPost = [];
  int _postCount = 10; 
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BackgroungHome(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SvgPicture.asset(
              'assets/ic_snapshare.svg',
              height: 32,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.facebookMessenger,
                color: kBlack,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => MessageScreen(),
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder(
          // stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          stream: FireStoreMethods.readPost(),
          // stream: FireStoreMethods.readPosts(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            // final data = snapshot.data?.docs;
            // _listPost =
            //     data?.map((e) => Post.fromJson(e.data())).toList() ?? [];
            // return ListView.builder(
            //   itemCount: snapshot.data?.docs.length,
            //   itemBuilder: (ctx, index) => Container(
            //     margin: EdgeInsets.symmetric(
            //       horizontal: width > webScreenSize ? width * 0.3 : 0,
            //       vertical: width > webScreenSize ? 15 : 0,
            //     ),
            //     child: PostCard(
            //       snap: snapshot.data!.docs[index].data(),
            //       idpost: snapshot.data!.docs[index].id,
            //     ),
            //   ),
            // );
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                    idpost: snapshot.data!.docs[index].id,
                  ),
                ),
              );
            } else {
              return const Center(
                // child: Text('No Connections Found!',
                //     style: TextStyle(fontSize: 20, color: kBlack)),
              );
            }
          },
        ),
      ),
    );
    ;
  }
}
