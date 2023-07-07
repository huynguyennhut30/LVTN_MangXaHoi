// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:lvtn_mangxahoi/models/user.dart';

class UserDesignWidget extends StatefulWidget {
  User? model;
  BuildContext? context;
  UserDesignWidget({
    Key? key,
    this.model,
    this.context,
  }) : super(key: key);

  @override
  State<UserDesignWidget> createState() => _UserDesignWidgetState();
}

class _UserDesignWidgetState extends State<UserDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.amberAccent,
                minRadius: 90.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.model!.photoUrl,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.model!.username,
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 20,
                  fontFamily: 'Bebas',
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.model!.email,
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
