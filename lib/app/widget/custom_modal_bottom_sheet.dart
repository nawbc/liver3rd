import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

showCustomModalBottomSheet({
  BuildContext context,
  Widget Function(BuildContext) builder,
  Function(BuildContext) handler,
  Widget child,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      if (handler != null) handler(context);
      return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: child,
              ),
            ),
          )
        ],
      );
    },
  );
}
