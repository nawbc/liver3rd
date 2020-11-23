import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool withBorder;

  const CustomTextField(
      {Key key, this.controller, this.hintText, this.withBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: withBorder
            ? Border.all(width: 2, color: Colors.grey[400])
            : Border.all(width: 0),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
