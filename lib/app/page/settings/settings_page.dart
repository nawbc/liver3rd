import 'package:flutter/material.dart';
import 'package:liver3rd/app/page/settings/forum_settings_fragment.dart';
import 'package:liver3rd/app/page/settings/other_settings_fragment.dart';
import 'package:liver3rd/app/page/settings/software_settings_fragment.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/title_divider.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  User _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidget.titleText('设置'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: Colors.grey),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: EasyRefresh.custom(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Column(children: [
                    if (_user.isLogin) ...[
                      TitleDivider(
                        height: 60,
                        title: Text('社区', style: TextStyle(fontSize: 14)),
                        color: Colors.blue[200],
                      ),
                      ForumSettingsFragment(),
                    ],
                    TitleDivider(
                      height: 60,
                      title: Text('软件', style: TextStyle(fontSize: 14)),
                      color: Colors.blue[200],
                    ),
                    SoftwareSettingsFragment(),
                    TitleDivider(
                      height: 60,
                      title: Text('其他', style: TextStyle(fontSize: 14)),
                      color: Colors.blue[200],
                    ),
                    OtherSettingsFragment(),
                  ]);
                }, childCount: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var settingsPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return SettingsPage();
  },
);
