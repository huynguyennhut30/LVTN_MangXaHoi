
// void onMessageSubmitted(ChatMessage message, String time) {
//     print(chatUser!.userId);

//     try {
//       // if (_messageList == null || _messageList.length < 1) {
//       kDatabase
//           .child('chatUsers')
//           .child(message.senderId)
//           .child(message.receiverId)
//           .set(message.toJson());

//       kDatabase
//           .child('chatUsers')
//           .child(chatUser!.userId!)
//           .child(message.senderId)
//           .set(message.toJson());

//       kDatabase
//           .child('chats')
//           .child(_channelName!)
//           .child(time)
//           .set(message.toJson());
//       sendAndRetrieveMessage(message);
//       Utility.logEvent('send_message', parameter: {});
//     } catch (error) {
//       cprint(error);
//     }
//   }


/********************************************************************************* */
// Thành Đạt
// Widget _body() {
//     final state = Provider.of<ChatState>(context);
//     final searchState = Provider.of<SearchState>(context, listen: false);
//     final aState = Provider.of<AuthState>(context, listen: false);

//     return StreamBuilder<DatabaseEvent>(
//       stream: kDatabase
//           .child('chatUsers')
//           .child(aState
//               .userId) // Replace state.userId with the appropriate user ID
//           .onValue,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else {
//           final chatUserList = <ChatMessage>[];
//           final data = snapshot.data?.snapshot;
//           if (data != null && data.value != null) {
//             final map = data.value as Map?;
//             if (map != null) {
//               map.forEach((key, value) {
//                 final model = ChatMessage.fromJson(value);
//                 model.key = key;
//                 chatUserList.add(model);
//               });
//             }
//             chatUserList.sort((x, y) {
//               if (x.createdAt != null && y.createdAt != null) {
//                 return DateTime.parse(y.createdAt!)
//                     .compareTo(DateTime.parse(x.createdAt!));
//               } else {
//                 if (x.createdAt != null) {
//                   return 0;
//                 } else {
//                   return 1;
//                 }
//               }
//             });
//           }

//           if (chatUserList.isEmpty) {
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: EmptyList(
//                 'No message available',
//                 subTitle:
//                     'When someone sends you a message, the user list will show up here.\nTo send a message, tap the message button.',
//               ),
//             );
//           } else {
//             return ListView.separated(
//               physics: const BouncingScrollPhysics(),
//               itemCount: chatUserList.length,
//               itemBuilder: (context, index) => _userCard(
//                 searchState.userlist!.firstWhere(
//                   (x) => x.userId == chatUserList[index].key,
//                   orElse: () => UserModel(userName: "Unknown"),
//                 ),
//                 chatUserList[index],
//               ),
//               separatorBuilder: (context, index) {
//                 return const Divider(
//                   height: 0,
//                 );
//               },
//             );
//           }
//         }
//       },
//     );
//   }

//   Widget _userCard(UserModel model, ChatMessage? lastMessage) {
//     final state = Provider.of<AuthState>(context, listen: false);
//     return Container(
//       color: Colors.white,
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//         onTap: () {
//           final chatState = Provider.of<ChatState>(context, listen: false);
//           final searchState = Provider.of<SearchState>(context, listen: false);

//           chatState.setChatUser = model;
//           if (lastMessage != null) {
//             lastMessage.seen = true;

//             DatabaseReference databaseRef = FirebaseDatabase.instance
//                 .ref()
//                 .child('chatUsers')
//                 .child(state.userId)
//                 .child(chatState.chatUser!.userId!);
//             databaseRef.update({
//               'seen': true,
//             }).then((_) {
//               // Update successful
//               // Save the updated message to the Realtime Database or your database if needed
//               // ...
//             }).catchError((error) {
//               // Update failed
//               if (kDebugMode) {
//                 print(error);
//               }
//               // Handle the error accordingly
//               // ...
//             });
//           }

//           if (searchState.userlist!.any((x) => x.userId == model.userId)) {
//             chatState.setChatUser = searchState.userlist!
//                 .where((x) => x.userId == model.userId)
//                 .first;
//           }

//           Navigator.pushNamed(context, '/ChatScreenPage');
//         },
//         leading: RippleButton(
//           onPressed: () {
//             Navigator.push(
//                 context, ProfilePage.getRoute(profileId: model.userId!));
//           },
//           borderRadius: BorderRadius.circular(28),
//           child: Container(
//             height: 56,
//             width: 56,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white, width: 2),
//               borderRadius: BorderRadius.circular(28),
//               image: DecorationImage(
//                   image: customAdvanceNetworkImage(
//                     model.profilePic ?? Constants.dummyProfilePic,
//                   ),
//                   fit: BoxFit.cover),
//             ),
//           ),
//         ),
//         title: TitleText(
//           model.displayName ?? "NA",
//           fontSize: 16,
//           fontWeight: FontWeight.w800,
//           overflow: TextOverflow.ellipsis,
//         ),
//         subtitle: customText(
//           getLastMessage(lastMessage?.message) ?? '@${model.displayName}',
//           style: TextStyles.onPrimarySubTitleText.copyWith(
//               color: lastMessage!.senderId == state.userId
//                   ? Colors.grey
//                   : lastMessage.seen == true
//                       ? Colors.grey
//                       : Colors.black,
//               fontWeight: FontWeight.bold),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         trailing: Text(
//           Utility.getChatTime(lastMessage.createdAt).toString(),
//           style: TextStyles.onPrimarySubTitleText.copyWith(
//               color: lastMessage.senderId == state.userId
//                   ? Colors.grey
//                   : lastMessage.seen == true
//                       ? Colors.grey
//                       : Colors.black,
//               fontSize: 12,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }