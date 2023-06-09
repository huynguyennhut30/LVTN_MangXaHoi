import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lvtn_mangxahoi/screens/profile_screen.dart';
import 'package:lvtn_mangxahoi/widgets/message/message_background.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../resources/firestore_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../utils/colors.dart';
import 'chat_user_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all users
  List<User> _list = [];

  // for storing searched items
  final List<User> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  late Size mq;

  @override
  Widget build(BuildContext context) {
    return MessageBackground(
      child: GestureDetector(
        //for hiding keyboard when a tap is detected on screen
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          //if search is on & back button is pressed then close search
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            //app bar
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MobileScreenLayout()),
                ),
                // icon: SvgPicture.asset('assets/button_back.svg'),
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: kBlack,
                ),
              ),
              title: _isSearching
                  ? TextField(
                      cursorColor: k1Gray,
                      decoration: const InputDecoration(
                          // border: InputBorder.none,
                          hoverColor: k1Gray,
                          hintText: 'Name, Email, ...'),
                      autofocus: true,
                      style: const TextStyle(
                          fontSize: 17, letterSpacing: 0.5, color: kBlack),
                      //when search text changes then updated search list
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.username
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                            setState(() {
                              _searchList;
                            });
                          }
                        }
                      },
                    )
                  : const Text('We Chat'),
              actions: [
                //search user button
                IconButton(
                    color: kBlack,
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),

                //more features button
                // IconButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (_) => ProfileScreen(uid: User.current!.uid)));
                //     },
                //     icon: const Icon(Icons.more_vert))
              ],
            ),

            //floating button to add new user
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: FloatingActionButton(
            //       onPressed: () {
            //         _addChatUserDialog();
            //       },
            //       child: const Icon(Icons.add_comment_rounded)),
            // ),
            body: StreamBuilder(
              stream:
                  FireStoreMethods.firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => User.fromJson(e.data())).toList() ??
                            [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        // padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index],
                          );
                          // return Text(
                          //   'Name: ${_list[index]}',
                          //   style: TextStyle(color: kBlack),
                          // );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No Connections Found!',
                            style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              },
            ),
            //body
            // body: Column(
            //   children: [
            //     // Container(
            //     //   margin: const EdgeInsets.only(top: 80.0),
            //     //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //     //   decoration: BoxDecoration(
            //     //     borderRadius: BorderRadius.circular(15.0),
            //     //     boxShadow: [
            //     //       BoxShadow(
            //     //         offset: const Offset(0, 4),
            //     //         blurRadius: 25.0,
            //     //         color: kBlack.withOpacity(0.10),
            //     //       )
            //     //     ],
            //     //   ),
            //     //   child: TextField(
            //     //     decoration: InputDecoration(
            //     //       filled: true,
            //     //       fillColor: kWhite,
            //     //       isDense: true,
            //     //       border: OutlineInputBorder(
            //     //         borderRadius: BorderRadius.circular(15.0),
            //     //         borderSide: const BorderSide(
            //     //           width: 0.0,
            //     //           style: BorderStyle.none,
            //     //         ),
            //     //       ),
            //     //       prefixIcon: SvgPicture.asset('assets/search.svg',
            //     //           fit: BoxFit.none),
            //     //       // prefixIcon: Icon(
            //     //       //   Icons.search,
            //     //       //   size: 30,
            //     //       // ),
            //     //       hintText: 'Search for contacts',
            //     //       hintStyle: Theme.of(context)
            //     //           .textTheme
            //     //           .labelSmall!
            //     //           .copyWith(color: k1LightGray),
            //     //     ),
            //     //   ),
            //     // ),
            //     ListView.builder(
            //       itemCount: 3,
            //       // padding: EdgeInsets.only(top: mq.height * .01),
            //       physics: const BouncingScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         return const ChatUserCard();
            //       },
            //     ),
            //     // StreamBuilder(
            //     //   stream: FireStoreMethods.getMyUsersId(),
            //     //   //get id of only known users
            //     //   builder: (context, snapshot) {
            //     //     switch (snapshot.connectionState) {
            //     //       //if data is loading
            //     //       case ConnectionState.waiting:
            //     //       case ConnectionState.none:
            //     //         return const Center(
            //     //             child: CircularProgressIndicator());
            //     //       //if some or all data is loaded then show it
            //     //       case ConnectionState.active:
            //     //       case ConnectionState.done:
            //     //         return StreamBuilder(
            //     //           stream: FireStoreMethods.getAllUsers(
            //     //               snapshot.data?.docs.map((e) => e.id).toList() ??
            //     //                   []),
            //     //           //get only those user, who's ids are provided
            //     //           builder: (context, snapshot) {
            //     //             switch (snapshot.connectionState) {
            //     //               //if data is loading
            //     //               case ConnectionState.waiting:
            //     //               case ConnectionState.none:
            //     //               // return const Center(
            //     //               //     child: CircularProgressIndicator());
            //     //               //if some or all data is loaded then show it
            //     //               case ConnectionState.active:
            //     //               case ConnectionState.done:
            //     //                 final data = snapshot.data?.docs;
            //     //                 _list = data
            //     //                         ?.map((e) => User.fromJson(e.data()))
            //     //                         .toList() ??
            //     //                     [];
            //     //                 if (_list.isNotEmpty) {
            //     //                   return ListView.builder(
            //     //                       itemCount: _isSearching
            //     //                           ? _searchList.length
            //     //                           : _list.length,
            //     //                       // padding: EdgeInsets.only(top: mq.height * .01),
            //     //                       physics: const BouncingScrollPhysics(),
            //     //                       itemBuilder: (context, index) {
            //     //                         return ChatUserCard(
            //     //                             user: _isSearching
            //     //                                 ? _searchList[index]
            //     //                                 : _list[index]);
            //     //                       });
            //     //                 } else {
            //     //                   return const Center(
            //     //                     child: Text('No Connections Found!',
            //     //                         style: TextStyle(fontSize: 20)),
            //     //                   );
            //     //                 }
            //     //             }
            //     //           },
            //     //         );
            //     //     }
            //     //   },
            //     // ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
