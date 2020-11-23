import 'package:flutter/widgets.dart';

import 'badge_position.dart';

class BadgePositioned extends StatelessWidget {
  final Widget child;
  final BadgePosition position;

  const BadgePositioned({Key key, this.position, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      final topRight = BadgePosition.topRight();
      return Positioned(
        top: topRight.top,
        right: topRight.right,
        child: child,
      );
    }
    return Positioned(
        top: position.top,
        right: position.right,
        bottom: position.bottom,
        left: position.left,
        child: child);
  }
}
