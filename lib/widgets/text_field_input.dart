import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon icon;

  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(29.0),
    );
    return TextField(
      controller: textEditingController,
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        fillColor: secondaryColor,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(14),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
