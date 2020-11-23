import 'package:flutter/widgets.dart';

class TitleDivider extends StatelessWidget {
  final double height;
  final double width;
  final Widget title;
  final double lineWidth;
  final EdgeInsetsGeometry padding;

  final Color color;

  const TitleDivider({
    Key key,
    this.height,
    this.width,
    this.title,
    this.color,
    this.lineWidth = 1,
    this.padding = const EdgeInsets.only(right: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null)
            Container(
                padding: EdgeInsets.only(left: 10, right: 10), child: title),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                  border: Border.all(width: lineWidth, color: color)),
            ),
          )
        ],
      ),
    );
  }
}
