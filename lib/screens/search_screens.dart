import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/models/post.dart';
import 'package:lvtn_mangxahoi/models/user.dart';
import 'package:lvtn_mangxahoi/screens/detail_post_screen.dart';
import 'package:lvtn_mangxahoi/screens/profile_screen.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';

class SearchScreens extends StatefulWidget {
  const SearchScreens({Key? key}) : super(key: key);

  @override
  State<SearchScreens> createState() => _SearchScreensState();
}

class _SearchScreensState extends State<SearchScreens> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = true;
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
                    hintText: 'Tìm kiếm người dùng hoặc hình ảnh...',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isShowUsers = true;
                    });
                  },
                  child: Container(
                    color: isShowUsers
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    height: 40,
                    child: const Center(
                      child: Text(
                        'Người dùng',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isShowUsers = false;
                    });
                  },
                  child: Container(
                    color: !isShowUsers
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    height: 40,
                    child: const Center(
                      child: Text(
                        'Hình ảnh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder<List<User>>(
              future: searchUsers(searchController.text),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.username),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: user.uid,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Lỗi: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : FutureBuilder<List<Post>>(
              future: searchPosts(searchController.text),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listPost = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.5,
                      mainAxisSpacing: 1.5,
                    ),
                    itemCount: listPost.length,
                    itemBuilder: (context, index) {
                      final post = listPost[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailPost(
                                idpost: post.postId,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          post.postUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Lỗi: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }

  Future<List<User>> searchUsers(String query) async {
    // Code để tìm kiếm người dùng theo query
    final usersRef = FirebaseFirestore.instance.collection('users');
    final snapshot =
        await usersRef.where('username', isGreaterThanOrEqualTo: query).get();
    final users =
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
    return users;
  }

  Future<List<Post>> searchPosts(String query) async {
    // Code để tìm kiếm các bài đăng theo query
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final snapshot =
        await postsRef.where('caption', isGreaterThanOrEqualTo: query).get();
    final posts =
        snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    return posts;
  }
}
