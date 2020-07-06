import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget content;
  final Color color;
  final double height;
  final double maxWidth;

  final VoidCallback onPressed;
  const CustomChip({
    Key key,
    this.content,
    this.color,
    this.height,
    @required this.onPressed,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: maxWidth == null
            ? BoxConstraints()
            : BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.only(left: 8, right: 8),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height)),
          color: color == null ? Colors.blue[200] : color,
        ),
        child: Center(child: content),
      ),
    );
  }
}
