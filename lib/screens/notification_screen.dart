import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/utils/key_shared.dart';
import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';
import 'package:lvtn_mangxahoi/widgets/background_home.dart';
import 'package:lvtn_mangxahoi/widgets/notification_card.dart';

class notificationScreen extends StatefulWidget {
  const notificationScreen({super.key});

  @override
  State<notificationScreen> createState() => _notificationScreenState();
}

class _notificationScreenState extends State<notificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroungHome(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "Thông báo",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto_light',
                      fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where("uid_recei",
                        isEqualTo: sharedPreferences.getString(keyShared.CURRENTUSER))
                   
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return snapshot.data!.docs[index].data()['uid_action']!=sharedPreferences.getString(keyShared.CURRENTUSER)
                        ?notificationCard(
                          snap: snapshot.data!.docs[index].data(),
                        ):SizedBox();
                      },
                    );
                  }else{
                    return Center(
                      child: Text("Chưa có thông báo",style: TextStyle(color: Colors.black),),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
