import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(
      source: source, maxHeight: 1920, maxWidth: 1080, imageQuality: 80);
  if (_file != null) {
    final bytes = await _file.readAsBytes();
    final sizeInMb =
        bytes.lengthInBytes / (1024 * 1024); // tính dung lượng ảnh đơn vị là MB

    if (sizeInMb > 30) {
      var context;
      showDialog(
        context: (context),
        builder: (context) => AlertDialog(
          title: Text('File size exceeded'),
          content: Text('Image size cannot exceed 30 MB.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      return await _file.readAsBytes();
    }

    // return await File(_file.path);
  }
  print('No Image');
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
