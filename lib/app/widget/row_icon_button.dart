import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class RowIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String text;

  const RowIconButton({Key key, this.icon, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onPressed != null ? onPressed : () {},
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(width: 5),
            NoScaledText(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
