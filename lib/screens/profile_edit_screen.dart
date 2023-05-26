import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lvtn_mangxahoi/resources/firestore_method.dart';
import 'package:lvtn_mangxahoi/resources/firestore_methods.dart';

class profileEditScreen extends StatefulWidget {
  final userData;
  profileEditScreen({super.key, required this.userData});

  @override
  State<profileEditScreen> createState() => _profileEditScreenState();
}

class _profileEditScreenState extends State<profileEditScreen> {
  StreamController<XFile?> _file = StreamController<XFile?>.broadcast();

  XFile? img = null;
  ImagePicker image = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final usernameED = TextEditingController();
    final bioED = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close)),
        title: Row(
          children: [
            Expanded(child: Text("Edit Profile")),
            GestureDetector(
                onTap: () async {
                  if (img != null) {
                    File imgs = File(img!.path);
                    Uint8List byte = await imgs.readAsBytes();
                    await fireMethod.updateInforUser(
                        file: byte,
                        id: widget.userData['uid'],
                        username: usernameED.text,
                        bio: bioED.text);
                  } else {
                    Uint8List? byte = null;
                    await fireMethod.updateInforUser(
                        file: byte,
                        id: widget.userData['uid'],
                        username: usernameED.text,
                        bio: bioED.text);
                  }

                  Navigator.pop(context);
                },
                child: Icon(Icons.check, color: HexColor("3f89b4"))),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: StreamBuilder(
                  stream: _file.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return ClipOval(
                        child: CircleAvatar(
                          radius: 100,
                          child: Image.network(
                            widget.userData['photoUrl'],
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          height: 100,
                          width: 100,
                          child: ClipOval(
                              child: Image.file(
                            File(snapshot.data!.path),
                            fit: BoxFit.fill,
                          )));
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  await getgall();
                },
                child: Text(
                  "Change profile photo",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          formInput(
            text: "Username",
            TextEditingController: usernameED,
            value: widget.userData['username'],
          ),
          SizedBox(
            height: 10,
          ),
          formInput(
            text: "Bio",
            TextEditingController: bioED,
            value: widget.userData["bio"],
          ),
        ],
      ),
    );
  }

  getgall() async {
    // ignore: deprecated_member_use
    img = await image.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _file.sink.add(img);
    }
  }
}

class formInput extends StatelessWidget {
  final String text;
  final TextEditingController;
  final String value;
  const formInput({
    super.key,
    required this.text,
    required this.TextEditingController,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController.text = value;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              )),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
                controller: TextEditingController,
                style: TextStyle(color: Colors.black, fontSize: 13)),
          )
        ],
      ),
    );
  }
}
