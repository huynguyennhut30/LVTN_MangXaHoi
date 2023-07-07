import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/models/user.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/widgets/user_design_widget.dart';

class SearchScreenss extends StatefulWidget {
  const SearchScreenss({super.key});

  @override
  State<SearchScreenss> createState() => _SearchScreenssState();
}

class _SearchScreenssState extends State<SearchScreenss> {
  String textUserName = '';
  Future<QuerySnapshot>? postDocumentsList;
  initSearchingPost(String textEntered) {
    postDocumentsList = FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: textEntered)
        .get();
    setState(() {
      postDocumentsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(125, 185, 179, 1),
            Colors.deepOrange
          ])),
        ),
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              textUserName = textEntered;
            });
            initSearchingPost(textEntered);
          },
          decoration: InputDecoration(
            hintText: 'Search... ',
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                initSearchingPost(textUserName);
              },
            ),
            prefixIcon: IconButton(
              icon: const Padding(
                padding: EdgeInsets.only(right: 12.0, bottom: 4.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: postDocumentsList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    User model = User.fromJson(snapshot.data!.docs[index]
                        .data()! as Map<String, dynamic>);
                    return UserDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'Not data',
                    style: TextStyle(color: kBlack),
                  ),
                );
        },
      ),
    );
  }
}
