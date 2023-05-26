import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lvtn_mangxahoi/models/user.dart' as model;
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utils/colors.dart';
import 'ImageAvt.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      padding: const EdgeInsets.all(14.0),
      height: size.height * 0.40,
      width: size.width,
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: NetworkImage(widget.snap['postUrl']),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap['profImage']),
                    maxRadius: 16.0,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: kWhite),
                      ),
                      Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: const Color(0xFFD8D8D8)),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: kWhite),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //dfsdfsdgsdgsgsgsdg
  Container _buildPostStat({
    required BuildContext context,
    required Icon iconPath,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5).withOpacity(0.40),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Row(
        children: [
          // SvgPicture.asset(
          //   iconPath,
          //   color: kWhite,
          // ),
          const SizedBox(width: 8.0),
          Text(
            value,
            style:
                Theme.of(context).textTheme.labelSmall!.copyWith(color: kWhite),
          ),
        ],
      ),
    );
  }
}
