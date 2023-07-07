import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<User> _listSort = [];

  // for storing searched items
  final List<User> _searchList = [];
  // for storing search status
  bool _isSearching = false;
  late User user;
  late Size mq;
  List<Message> _listMessage = [];
  Message? message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onNewMessage(User users) {
    setState(() {
      _list.insert(0, users);
    });
  }
//   void _onNewMessage(Message message) {
//   setState(() {
//     // Tìm kiếm user tương ứng trong danh sách
//     final user = _list.firstWhere((u) => u.uid == message.sent);
//     // Cập nhật thời gian tin nhắn mới nhất của user
//     // user.lastMessageTime = message.time;
//     // Sắp xếp lại danh sách theo thứ tự tin nhắn mới nhất
//     // _list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
//   });
// }

  @override
  Widget build(BuildContext context) {
    // _listMessage.sort((a, b) => b.sent.compareTo(a.sent));
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
                icon: const Icon(
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
                        hintText: 'Name, Email, ...',
                        hintStyle: TextStyle(color: kBlack),
                      ),
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

            body: StreamBuilder(
              // stream:
                  // FireStoreMethods.firestore.collection('users').snapshots(),
              stream: FireStoreMethods.getChat(),
              // stream: FireStoreMethods.getChatList(),
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
                        // _list.sort((a, b) => b.,)
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index],
                          );
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
            // body: StreamBuilder(
            //   stream: FireStoreMethods.getAllUserChat(),
            //   //get id of only known users
            //   builder: (context, snapshot) {
            //     switch (snapshot.connectionState) {
            //       //if data is loading
            //       case ConnectionState.waiting:
            //       case ConnectionState.none:
            //         return const Center(child: CircularProgressIndicator());
            //       //if some or all data is loaded then show it
            //       case ConnectionState.active:
            //       case ConnectionState.done:
            //         return StreamBuilder(
            //           stream: FireStoreMethods.getAllUsers(
            //               snapshot.data?.docs.map((e) => e.id).toList() ?? []),
            //           //get only those user, who's ids are provided
            //           builder: (context, snapshot) {
            //             switch (snapshot.connectionState) {
            //               //if data is loading
            //               case ConnectionState.waiting:
            //               case ConnectionState.none:
            //               // return const Center(
            //               //     child: CircularProgressIndicator());
            //               //if some or all data is loaded then show it
            //               case ConnectionState.active:
            //               case ConnectionState.done:
            //                 final data = snapshot.data?.docs;
            //                 _list = data
            //                         ?.map((e) => User.fromJson(e.data()))
            //                         .toList() ??
            //                     [];
            //                 if (_list.isNotEmpty) {
            //                   return ListView.builder(
            //                       itemCount: _isSearching
            //                           ? _searchList.length
            //                           : _list.length,
            //                       padding:
            //                           EdgeInsets.only(top: mq.height * .01),
            //                       physics: const BouncingScrollPhysics(),
            //                       itemBuilder: (context, index) {
            //                         return ChatUserCard(
            //                             user: _isSearching
            //                                 ? _searchList[index]
            //                                 : _list[index]);
            //                       });
            //                 } else {
            //                   return const Center(
            //                     child: Text('No Connections Found!',
            //                         style: TextStyle(fontSize: 20)),
            //                   );
            //                 }
            //             }
            //           },
            //         );
            //     }
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}
