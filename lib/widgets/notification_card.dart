

import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';
import 'package:lvtn_mangxahoi/screens/detail_post_screen.dart';



class notificationCard extends StatelessWidget {
  final snap;
  const notificationCard({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    String getSnap(){
        String a = snap['postId'];
        return a;
    }
    return InkWell(
      onTap: () async {
        final snapP = await fireMethod.getPostByID(getSnap());
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return detailPost(snap: snapP,idpost: snap!['postId'],);
        },
        )
        );
      },
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                image: DecorationImage(
                  image: NetworkImage(snap['uid_action_image']),
                  fit: BoxFit.cover
                )
              ),
            ),
            snap['content']=="like"?
            Row(
              children: [
                Text(snap['uid_action_name'],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                Text(" đã like bài viết của bạn",style: TextStyle(color: Colors.black),),
              ],
            )
            : Row(
              children: [
                Text(snap['uid_action_name'],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                Text(" đã bình luận bài viết của bạn",style: TextStyle(color: Colors.black),),
              ],
            )
    
          ],
        ),
      ),
    );
  }
}