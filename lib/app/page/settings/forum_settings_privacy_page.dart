import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class ForumSettingsPrivacyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForumSettingsPrivacyPageState();
  }
}

class _ForumSettingsPrivacyPageState extends State<ForumSettingsPrivacyPage> {
  ForumApi _forumApi = ForumApi();
  User _user;
  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    Map p =
        _user.info['data']['user_info']['community_info']['privacy_invisible'];

    switch1 = p['post'];
    switch2 = p['collect'];
    switch3 = p['watermark'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidget.titleText('隐私'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            OptionItem(
              title: TextSnack['setting_p1'],
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {
                await _forumApi.setUserPrivacy(
                  gids: '1',
                  post: !switch1,
                  collect: switch2,
                  watermark: switch3,
                );
                await _user.getMyFullInfo();
                setState(() {
                  switch1 = !switch1;
                });
              },
              shadow: null,
              extend: CustomSwitchButton(
                backgroundColor: Colors.blue[200],
                unCheckedColor: Colors.white,
                animationDuration: Duration(milliseconds: 400),
                checkedColor: Colors.white,
                checked: !switch1,
              ),
            ),
            OptionItem(
              title: TextSnack['setting_p2'],
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {
                await _forumApi.setUserPrivacy(
                  gids: '1',
                  post: switch1,
                  collect: !switch2,
                  watermark: switch3,
                );
                await _user.getMyFullInfo();
                setState(() {
                  switch2 = !switch2;
                });
              },
              shadow: null,
              extend: CustomSwitchButton(
                backgroundColor: Colors.blue[200],
                unCheckedColor: Colors.white,
                animationDuration: Duration(milliseconds: 400),
                checkedColor: Colors.white,
                checked: !switch2,
              ),
            ),
            OptionItem(
              title: TextSnack['setting_p3'],
              titleColor: Colors.grey,
              subTitleColor: Colors.grey[400],
              color: Colors.grey[200],
              onPress: () async {
                await _forumApi.setUserPrivacy(
                  gids: '1',
                  post: switch1,
                  collect: switch2,
                  watermark: !switch3,
                );
                await _user.getMyFullInfo();
                setState(() {
                  switch3 = !switch3;
                });
              },
              shadow: null,
              extend: CustomSwitchButton(
                backgroundColor: Colors.blue[200],
                unCheckedColor: Colors.white,
                animationDuration: Duration(milliseconds: 400),
                checkedColor: Colors.white,
                checked: !switch3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var forumSettingsPrivacyPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return ForumSettingsPrivacyPage();
  },
);
