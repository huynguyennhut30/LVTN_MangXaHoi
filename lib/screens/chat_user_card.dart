import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/chat_detail_screen.dart';

import '../main.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/colors.dart';
import '../widgets/my_date_util.dart';

class ChatUserCard extends StatefulWidget {
  final User user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.4, vertical: 4),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Color.fromARGB(255, 238, 235, 235).withOpacity(0.6),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                user: widget.user,
              ),
            ),
          );
        },
        // padding: const EdgeInsets.all(16.0),
        // margin: const EdgeInsets.only(bottom: 16.0),
        // decoration: BoxDecoration(
        //   color: kWhite.withOpacity(0.60),
        //   borderRadius: BorderRadius.circular(32.0),
        // ),
        child: StreamBuilder(
          stream: FireStoreMethods.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              _message = list[0];
            }
            return ListTile(
              // contentPadding: const EdgeInsets.all(10.0),
              leading: Transform.scale(
                scale: 1.3,
                child: CircleAvatar(
                  // child: Icon(CupertinoIcons.person),
                  // child: Image(image: NetworkImage(widget.user.photoUrl)),
                  // radius: 10,
                  backgroundImage: NetworkImage(
                    widget.user.photoUrl,
                  ),
                  maxRadius: 16.0,
                ),
              ),
              title: Text(
                widget.user.username,
                style: TextStyle(color: kBlack),
              ),
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? 'Đã gửi ảnh'
                        : _message!.msg
                    : widget.user.bio,
                maxLines: 1,
                style: TextStyle(color: kBlack),
              ),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty &&
                          _message!.fromId != FireStoreMethods.user.uid
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )
                      : Text(
                          MyDateUtil.getFormattedTime(
                              context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.black54)),
              // trailing: Text(
              //   '12h',
              //   style: TextStyle(
              //     color: kBlack,
              //   ),
              // ),
            );
          },
        ),
      ),
    );
  }
}
