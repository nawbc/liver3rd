import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show PlaceholderAlignment;

// 可缓存的image span
class CachedImageSpan extends ExtendedWidgetSpan {
  final double width;
  CachedImageSpan(
      {Key key,
      @required double imageWidth,
      ImageProvider image,
      String imageUrl,
      double imageHeight,
      EdgeInsets margin,
      int start = 0,
      String actualText,
      TextBaseline baseline,
      TextStyle style,
      BoxFit fit: BoxFit.scaleDown,
      PlaceholderWidgetBuilder placeholder,
      AlignmentGeometry imageAlignment = Alignment.center,
      Color color,
      BlendMode colorBlendMode,
      ImageRepeat repeat = ImageRepeat.noRepeat,
      bool matchTextDirection = false,
      FilterQuality filterQuality = FilterQuality.low,
      GestureTapCallback onTap,
      HitTestBehavior behavior = HitTestBehavior.deferToChild,
      ui.PlaceholderAlignment alignment = ui.PlaceholderAlignment.bottom,
      bool isCached = true,
      ImageLoadingBuilder loadingBuilder,
      ImageFrameBuilder frameBuilder,
      String semanticLabel,
      bool excludeFromSemantics = false,
      bool gaplessPlayback = false,
      Rect centerSlice,
      double containerWidth})
      : assert(imageWidth != null),
        assert(fit != null),
        width = imageWidth + (margin == null ? 0 : margin.horizontal),
        super(
          child: Container(
            width: containerWidth ?? imageWidth,
            alignment: imageAlignment,
            child: Container(
              padding: margin,
              width: imageWidth,
              height: imageHeight,
              color: color,
              child: GestureDetector(
                onTap: onTap,
                behavior: behavior,
                child: isCached
                    ? CachedNetworkImage(
                        imageUrl: imageUrl ?? '',
                        placeholder: placeholder,
                        fit: fit,
                        repeat: repeat,
                        matchTextDirection: matchTextDirection,
                        filterQuality: filterQuality,
                        colorBlendMode: colorBlendMode,
                        alignment: imageAlignment,
                      )
                    : Image(
                        key: key,
                        image: image,
                        width: imageWidth,
                        height: imageHeight,
                        fit: fit,
                        loadingBuilder: loadingBuilder,
                        frameBuilder: frameBuilder,
                        semanticLabel: semanticLabel,
                        excludeFromSemantics: excludeFromSemantics,
                        color: color,
                        colorBlendMode: colorBlendMode,
                        alignment: imageAlignment,
                        repeat: repeat,
                        centerSlice: centerSlice,
                        matchTextDirection: matchTextDirection,
                        gaplessPlayback: gaplessPlayback,
                        filterQuality: filterQuality,
                      ),
              ),
            ),
          ),
          baseline: baseline,
          alignment: alignment,
          start: start,
          deleteAll: true,
          actualText: actualText,
        );
}
