import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class BottomDynamicDisplayButton {
  OverlayEntry overlayEntry;
  Timer _timer;

  void show(BuildContext context, String content,
      {Function onPressed, int duration = 5}) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            bottom: 60,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Center(
                child: RaisedButton(
                  padding: EdgeInsets.all(0),
                  color: Colors.blue[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: NoScaledText(
                    content,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      color: Colors.white,
                    ),
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          );
        },
      );
      Overlay.of(context).insert(overlayEntry);

      _timer = Timer(Duration(seconds: duration), () {
        remove();
      });
    }
  }

  void remove() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}
