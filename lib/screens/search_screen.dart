import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/detail_post_screen.dart';
import 'package:lvtn_mangxahoi/screens/profile_screen.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lvtn_mangxahoi/utils/global_variables.dart';

import '../models/post.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  List<Post> listPost = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 193, 190, 190)),
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for a user...',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onFieldSubmitted: (String _) {
                    setState(() {
                      isShowUsers = true;
                    });
                    print(_);
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(40)),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 27,
              ),
            ),
          ],
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .limit(5)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                          style: const TextStyle(color: kBlack),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              // future: FirebaseFirestore.instance
              // .collection('posts')
              // .orderBy('datePublished')
              // .get(),
              future: FireStoreMethods.getPostsByUserTopics(),
              builder: (context, snapshot) {
                // final data = snapshot.data?.docs;
                // listPost =
                //     data?.map((e) => Post.fromJson(e.data())).toList() ?? [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  // itemBuilder: (context, index) => Image.network(
                  //   (snapshot.data! as dynamic).docs[index]['postUrl'],
                  //   // listPost[index].postUrl,
                  //   fit: BoxFit.cover,
                  // ),
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
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );

                // if (listPost.isNotEmpty) {
                //   return StaggeredGridView.countBuilder(
                //     crossAxisCount: 3,
                //     itemCount: (snapshot.data! as dynamic).docs.length,
                //     itemBuilder: (context, index) => Image.network(
                //       // (snapshot.data! as dynamic).docs[index]['postUrl'],
                //       listPost[index].postUrl,
                //       fit: BoxFit.cover,
                //     ),
                //     staggeredTileBuilder: (index) => MediaQuery.of(context)
                //                 .size
                //                 .width >
                //             webScreenSize
                //         ? StaggeredTile.count(
                //             (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                //         : StaggeredTile.count(
                //             (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                //     mainAxisSpacing: 8.0,
                //     crossAxisSpacing: 8.0,
                //   );
                // } else {
                //   return const Center(
                //     child: Text('No Connections Found!',
                //         style: TextStyle(fontSize: 20, color: kBlack)),
                //   );
                // }
              },
            ),
    );
  }
}
