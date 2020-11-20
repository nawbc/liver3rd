import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class ColIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String title;
  final double width;

  const ColIconButton(
      {Key key, @required this.icon, this.onPressed, this.title, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              child: icon,
            ),
            SizedBox(height: 4),
            NoScaledText(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
