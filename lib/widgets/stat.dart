import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lvtn_mangxahoi/utils/color_config.dart';
 

class Stat extends StatelessWidget {
  const Stat({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(color: kCaption),
        ),
        Text(
          NumberFormat.decimalPattern().format(value),
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ],
    );
  }
}