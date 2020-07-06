import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show PlaceholderAlignment;

import 'package:liver3rd/app/widget/simple_video_player.dart';

// 可缓存的image span
class VideoSpan extends ExtendedWidgetSpan {
  VideoSpan({
    Key key,
    double videoWidth,
    @required String url,
    @required Map header,
    EdgeInsets margin,
    int start = 0,
    String actualText,
    TextBaseline baseline,
    TextStyle style,
    AlignmentGeometry videoAlignment = Alignment.center,
    GestureTapCallback onTap,
    HitTestBehavior behavior = HitTestBehavior.deferToChild,
    ui.PlaceholderAlignment alignment = ui.PlaceholderAlignment.bottom,
  }) : super(
          child: Container(
            alignment: videoAlignment,
            width: videoWidth,
            child: GestureDetector(
              onTap: onTap,
              behavior: behavior,
              child: SimpleVideoPlayer(url: null),
            ),
          ),
          style: style,
          baseline: baseline,
          alignment: alignment,
          start: start,
          deleteAll: true,
          actualText: actualText,
        );
}
