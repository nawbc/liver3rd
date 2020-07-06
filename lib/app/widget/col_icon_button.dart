import 'package:flutter/material.dart';

class ColIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String title;

  const ColIconButton(
      {Key key, @required this.icon, this.onPressed, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              child: icon,
            ),
            SizedBox(height: 4),
            Text(
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
