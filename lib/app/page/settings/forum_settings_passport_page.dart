import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class ForumSettingsPassportPagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForumSettingsPassportPagetate();
  }
}

class _ForumSettingsPassportPagetate
    extends State<ForumSettingsPassportPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidget.titleText('通行证'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            OptionItem(
              title: '收货地址',
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {},
              shadow: null,
            ),
            OptionItem(
              title: '修改密码',
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {},
              shadow: null,
            ),
            OptionItem(
              title: '账号安全设置',
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {},
              shadow: null,
            ),
          ],
        ),
      ),
    );
  }
}

var forumSettingsPassportPagedler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return ForumSettingsPassportPagePage();
  },
);
