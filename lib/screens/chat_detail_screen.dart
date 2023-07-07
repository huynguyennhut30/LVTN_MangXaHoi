import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lvtn_mangxahoi/models/user.dart';
import 'package:lvtn_mangxahoi/screens/view_profile_screen.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';
import 'package:lvtn_mangxahoi/widgets/message_details/message_detail_background.dart';
import 'package:lvtn_mangxahoi/widgets/my_date_util.dart';

import '../models/message.dart';
import '../resources/firestore_methods.dart';
import '../widgets/message_card.dart';

class ChatDetailScreen extends StatefulWidget {
  final User? user;
  const ChatDetailScreen({super.key, this.user});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return MessageDetailBackground(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FireStoreMethods.getAllMessages(widget.user!),
                    // stream: FireStoreMethods.getAllChat(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          // _list.sort(((a, b) => a.sent.compareTo(b.sent)));
                          // _list.clear();
                          // _list.add(
                          //   Message(
                          //       toId: 'abc',
                          //       msg: 'Hi',
                          //       read: '',
                          //       type: Type.text,
                          //       fromId: FireStoreMethods.user.uid,
                          //       sent: '12:00'),
                          // );
                          // _list.add(
                          //   Message(
                          //       toId: FireStoreMethods.user.uid,
                          //       msg: 'Hello',
                          //       read: '',
                          //       type: Type.text,
                          //       fromId: 'abc',
                          //       sent: '12:00'),
                          // );
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              // padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('Say Hii!👋',
                                  style:
                                      TextStyle(fontSize: 20, color: kBlack)),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  const Align(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: EmojiPicker(
                      onEmojiSelected: (category, Emoji emoji) {},
                      onBackspacePressed: () {},
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Colors.transparent,
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(
                      user: widget.user!,
                    )));
      },
      child: StreamBuilder(
        stream: FireStoreMethods.getUserInfo(widget.user!),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => User.fromJson(e.data())).toList() ?? [];
          return Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: kBlack,
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  list.isNotEmpty ? list[0].photoUrl : widget.user!.photoUrl,
                ),
                maxRadius: 16.0,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].username : widget.user!.username,
                    style: const TextStyle(
                      color: kBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? 'Online'
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive)
                        : MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive: widget.user!.lastActive),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: const Color.fromARGB(43, 34, 105, 226),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            shadowColor: Colors.transparent,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() => _showEmoji = !_showEmoji);
                  },
                  icon: const Icon(
                    Icons.emoji_emotions,
                    size: 25,
                    color: Colors.blueAccent,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    maxLines: null,
                    style: const TextStyle(color: kBlack),
                    decoration: const InputDecoration(
                      hintText: 'Nhắn tin...',
                      hintStyle: TextStyle(
                        color: k1Gray,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);
                    for (var i in images) {
                      // log('Image Path: ${image.path}');
                      setState(() => _isUploading = true);
                      await FireStoreMethods.sendChatImage(
                          widget.user!, File(i.path));
                      setState(() => _isUploading = false);
                    }
                  },
                  icon: const Icon(
                    Icons.image,
                    size: 25,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      // log('Image Path: ${image.path}');
                      setState(() => _isUploading = true);

                      await FireStoreMethods.sendChatImage(
                          widget.user!, File(image.path));
                      setState(() => _isUploading = false);
                    }
                  },
                  icon: const Icon(
                    Icons.camera,
                    size: 25,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              if (_list.isEmpty) {
                FireStoreMethods.sendFirstMessage(
                    widget.user!, _textController.text, Type.text);
              } else {
                FireStoreMethods.sendMessage(
                    widget.user!, _textController.text, Type.text);
                _textController.text = '';
              }
            }
          },
          shape: const CircleBorder(side: BorderSide.none),
          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
          minWidth: 0,
          color: kWhite,
          child: const Icon(
            Icons.send,
            color: Colors.blueAccent,
            size: 28,
          ),
        )
      ],
    );
  }
}
