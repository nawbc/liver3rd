import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CommonWidget {
  static Widget snack(String content, {Duration duration, bool isError}) {
    return SnackBar(
      duration: duration != null ? duration : Duration(milliseconds: 4000),
      content: NoScaledText(
        content,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: isError != null ? Colors.red : Colors.blue[200],
    );
  }

  static button({
    double width,
    String content,
    VoidCallback onPressed,
    Widget child,
    double height,
    Color color = const Color(0xff90caf9),
    TextStyle textStyle = const TextStyle(fontSize: 12),
    double elevation = null,
  }) =>
      Container(
        height: height,
        width: width,
        child: RaisedButton(
          elevation: elevation,
          disabledColor: Colors.grey[300],
          padding: EdgeInsets.all(0),
          disabledTextColor: Colors.white,
          color: color,
          colorBrightness: Brightness.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: child != null
              ? child
              : NoScaledText(content,
                  style: textStyle, overflow: TextOverflow.ellipsis),
          onPressed: onPressed,
        ),
      );

  static tabTitle(String val,
          {double fontSize = 18, color = const Color(0xFF9E9E9E)}) =>
      NoScaledText(
        val,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w400,
        ),
      );

  static ghostButton({
    @required double width,
    String content,
    @required Function onPressed,
    Widget child,
    double height,
    // Color color = const Color(0xff90caf9),
    TextStyle textStyle = const TextStyle(fontSize: 12),
  }) =>
      Container(
        height: height,
        width: width,
        child: RaisedButton(
          disabledColor: Colors.grey[300],
          padding: EdgeInsets.all(0),
          disabledTextColor: Colors.white,
          // color: color,
          colorBrightness: Brightness.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child:
              child != null ? child : NoScaledText(content, style: textStyle),
          onPressed: onPressed,
        ),
      );

  static Widget titleText(String text) {
    return NoScaledText(
      text,
      style: TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  static Widget noDataWidget(bool isLoadEmpty, hasPermission) {
    if (isLoadEmpty) {
      return EmptyWidget(
        title: TextSnack['empty'],
      );
    }
    if (!hasPermission) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            NoScaledText(
              "没有权限",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }
    return null;
  }

  static Widget loading({double size = 40}) => Center(
        child: LoadingBouncingGrid.square(
          backgroundColor: Colors.blue[200],
          borderSize: 0,
          size: size,
        ),
      );

  // static

  static Widget borderTextField({
    TextEditingController textController,
    String hintText = '',
    double textSize = 20,
    bool withBorder = false,
    double width,
    double height,
    Function onTap,
    int minLines,
    int maxLines,
    int maxLength,
    bool enabled = true,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.only(left: 10),
    void Function(String) onSubmit,
    TextInputType keyboardType = TextInputType.text,
  }) =>
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border:
              withBorder ? Border.all(width: 2, color: Colors.grey[400]) : null,
        ),
        child: Center(
          child: TextField(
            enabled: enabled,
            minLines: minLines,
            maxLines: maxLines,
            maxLength: maxLength,
            onTap: onTap,
            onSubmitted: onSubmit,
            controller: textController,
            style: TextStyle(
              fontSize: textSize,
              color: Colors.grey[600],
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: contentPadding,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: textSize,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      );
}
