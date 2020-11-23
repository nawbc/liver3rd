import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class YsRolePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _YsRolePageState();
  }
}

class _YsRolePageState extends State<YsRolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidget.titleText('原神角色'),
        elevation: 0,
        leading: CustomIcons.back(context),
      ),
      body: EmptyWidget(
        type: 'ys',
        title: '施工中',
        subTitle: '敬请期待',
      ),
    );
  }
}

var ysRolePageHandler = Handler(
  transactionType: TransactionType.fromLeft,
  pageBuilder: (BuildContext context, arg) {
    return YsRolePage();
  },
);
