import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';

class ShopAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopAccountPage();
  }
}

class _ShopAccountPage extends State<ShopAccountPage> {
  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      type: 'ys',
      title: '施工中',
    );
  }
}
