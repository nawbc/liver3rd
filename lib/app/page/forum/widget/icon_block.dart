import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class IconBlock extends StatelessWidget {
  final Function onTap;
  final String text;
  final Widget icon;

  const IconBlock({Key key, this.onTap, this.text, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        height: 40,
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(width: 5),
                  NoScaledText(
                    text,
                    style: TextStyle(fontSize: 14, color: Colors.black45),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
