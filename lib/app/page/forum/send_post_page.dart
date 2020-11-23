import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class SendPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SendPostPageState();
  }
}

class _SendPostPageState extends State<SendPostPage> {
  Widget _card({
    String title,
    String subTitle,
    Widget icon,
    Color color,
    VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(width: 3, color: Colors.grey[400]),
        ),
        width: double.infinity,
        height: 85,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: icon,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NoScaledText(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  NoScaledText(
                    subTitle,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 18, right: 18),
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _card(
              color: Colors.blue[200],
              icon: CustomIcons.workspace(width: 55),
              title: '帖子',
              subTitle: '讨论, 分析, 攻略, 水日长',
              onPressed: () {
                Navigate.navigate(context, 'posteditor');
              },
            ),
            SizedBox(height: 15),
            _card(
              color: Colors.amber[300],
              icon: CustomIcons.picture(width: 55),
              title: '图片',
              subTitle: '绘画, Cos, 手工, 表情包',
            ),
          ],
        ),
      ),
    );
  }
}
