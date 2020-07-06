import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';

class OrderDarwer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderDrawerState();
  }
}

class _OrderDrawerState extends State<OrderDarwer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: EmptyWidget(
          type: 'ys',
          title: '施工中',
        ),
      ),
    );
  }
}
