import 'package:flutter/material.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class SelectGamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectGamePageState();
  }
}

class _SelectGamePageState extends State<SelectGamePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
            Navigate.navigate(context, 'bhselect');
          },
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.amber),
            child: Center(
              child: Image.asset(bhLogoPath, width: 165),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
            Navigate.navigate(context, 'ysselect');
          },
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color(0xff111111)),
            child: Center(
              child: Image.asset(ysLogoPath, width: 220),
            ),
          ),
        ),
      )
    ]);
  }
}

var selectGamePageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return SelectGamePage();
  },
);
