import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan parseEmojiText({
  String str,
  TextSpan head,
  double lineSpacing,
  @required Map emojis,
  double fontSize,
  Color color = const Color(0xff242424),
  FontWeight fontWeight,
  FontStyle fontStyle = FontStyle.normal,
  Function onPressed,
}) {
  var pureText = "";
  var emojiName = "";
  // 默认0 匹配文字 1 时匹配flag
  var mode = 0;
  List<InlineSpan> textSpanList = [];
  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  void addToTextSpan(pureText) {
    textSpanList.add(
      TextSpan(
        text: pureText,
        recognizer: _tapGestureRecognizer..onTap = onPressed ?? () {},
        style: TextStyle(
          height: lineSpacing,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
        ),
      ),
    );
  }

  if (head != null) textSpanList.add(head);
  if (RegExp(r"(_\([\u4e00-\u9fa5]+\))").stringMatch(str) == null) {
    addToTextSpan(str);
  } else {
    for (var i = 0; i < str.length; i++) {
      if (mode == 0) {
        if (str[i] + (i != str.length - 1 ? str[i + 1] : '') == '_(') {
          addToTextSpan(pureText);
          pureText = "";
          mode = 1;
        } else {
          pureText += str[i];
          if (i == str.length - 1) {
            addToTextSpan(pureText);
          }
        }
      } else {
        if (str[i] == '(') {
          continue;
        } else if (str[i] == ')') {
          textSpanList.add(
            WidgetSpan(
              child: Container(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: emojis[emojiName],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

          emojiName = "";
          mode = 0;
        } else {
          emojiName += str[i];
        }
      }
    }
  }

  return TextSpan(children: textSpanList);
}
