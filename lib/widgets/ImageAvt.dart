

import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  final String imageUrl;
  const ImageAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl);
  }
}