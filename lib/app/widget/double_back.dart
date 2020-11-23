import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class DoubleClickBackWrapper
    extends StatelessWidget /* State<DoubleClickBackWrapper> */ {
  Widget child;
  DateTime _lastPressedTime;
  DoubleClickBackWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () async {
        if (_lastPressedTime == null ||
            DateTime.now().difference(_lastPressedTime) >
                Duration(seconds: 1)) {
          _lastPressedTime = DateTime.now();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: NoScaledText(
                "再次滑动或点击,退出程序",
                style: TextStyle(fontSize: ScreenUtil().setSp(40)),
              ),
              backgroundColor: Colors.blue[200],
            ),
          );
          return false;
        }
        exit(0);
        return true;
      },
    );
  }
}
