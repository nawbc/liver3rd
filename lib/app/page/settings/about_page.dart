import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidget.titleText('关于'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              logoPath,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 30),
            OptionItem(
              title: '作者',
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {
                Navigate.navigate(context, 'inapppurchase');
              },
              extend: NoScaledText('sewerganger'),
              shadow: null,
            ),
            OptionItem(
              title: '开源协议',
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {
                Navigate.navigate(context, 'about');
              },
              extend: NoScaledText('GPL-3.0'),
              shadow: null,
            ),
            OptionItem(
              title: 'Github',
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {
                TinyUtils.openUrl('https://github.com/sewerganger/liver3rd/');
              },
              shadow: null,
            ),
          ],
        ),
      ),
    );
  }
}

Handler aboutPageHandler = Handler(
  transactionType: TransactionType.fromRight,
  pageBuilder: (BuildContext context, arg) {
    return AboutPage();
  },
);
