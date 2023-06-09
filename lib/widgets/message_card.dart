import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/models/message.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';

import 'my_date_util.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FireStoreMethods.user.uid == widget.message.fromId
        ? _greenMessage()
        : _greyMesage();
  }

  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      FireStoreMethods.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? 3 : 4),
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.3),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: 4),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greyMesage() {
    if (widget.message.read.isEmpty) {
      FireStoreMethods.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(13),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 213, 220, 223),
              borderRadius: BorderRadius.circular(18),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 15,
                    ),
                  )
                : ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 5),
        Row(
          children: [
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(width: 2),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(13),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 245, 255),
              borderRadius: BorderRadius.circular(18),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 15,
                    ),
                  )
                : ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
  // Widget _greenMessage() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       //message time
  //       Row(
  //         children: [
  //           //for adding some space
  //           SizedBox(width: 5),
  //           //double tick blue icon for message read
  //           if (widget.message.read.isNotEmpty)
  //             const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
  //           //for adding some space
  //           const SizedBox(width: 2),
  //           //sent time
  //           Text(
  //             MyDateUtil.getFormattedTime(
  //                 context: context, time: widget.message.sent),
  //             style: const TextStyle(fontSize: 13, color: Colors.black54),
  //           ),
  //         ],
  //       ),
  //       //message content
  //       Flexible(
  //         child: Container(
  //           padding: EdgeInsets.all(widget.message.type == Type.image
  //               ? 3
  //               : 4),
  //           margin: EdgeInsets.symmetric(
  //               horizontal: 4, vertical: 1),
  //           decoration: BoxDecoration(
  //               color: const Color.fromARGB(255, 218, 255, 176),
  //               border: Border.all(color: Colors.lightGreen),
  //               //making borders curved
  //               borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(30),
  //                   topRight: Radius.circular(30),
  //                   bottomLeft: Radius.circular(30))),
  //           child: widget.message.type == Type.text
  //               ?
  //               //show text
  //               Text(
  //                   widget.message.msg,
  //                   style: const TextStyle(fontSize: 15, color: Colors.black87),
  //                 )
  //               :
  //               //show image
  //               ClipRRect(
  //                   borderRadius: BorderRadius.circular(15),
  //                   child: CachedNetworkImage(
  //                     imageUrl: widget.message.msg,
  //                     placeholder: (context, url) => const Padding(
  //                       padding: EdgeInsets.all(8.0),
  //                       child: CircularProgressIndicator(strokeWidth: 2),
  //                     ),
  //                     errorWidget: (context, url, error) =>
  //                         const Icon(Icons.image, size: 70),
  //                   ),
  //                 ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
