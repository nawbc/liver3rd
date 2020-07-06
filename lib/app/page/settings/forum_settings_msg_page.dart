import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/app/widget/title_divider.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class ForumSettingsMsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForumSettingsMsgPageState();
  }
}

class _ForumSettingsMsgPageState extends State<ForumSettingsMsgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CommonWidget.titleText('消息通知'),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
        ),
        body: DefaultTextStyle(
          style: TextStyle(color: Colors.grey),
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              children: [
                TitleDivider(
                  height: 60,
                  title: Text('有以下消息通知我', style: TextStyle(fontSize: 14)),
                  color: Colors.blue[200],
                ),
                OptionItem(
                  title: '有人私信给我',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
                OptionItem(
                  title: '有人评论或回复我',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
                OptionItem(
                  title: '有人给我点赞',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
                OptionItem(
                  title: '有人关注了我',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
                OptionItem(
                  title: '系统通知',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
                TitleDivider(
                  height: 60,
                  title: Text('陌生人私信过滤', style: TextStyle(fontSize: 14)),
                  color: Colors.blue[200],
                ),
                OptionItem(
                  title: '不接受未关注人私信',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
                OptionItem(
                  title: '合并未关注人私信',
                  titleColor: Colors.grey,
                  subTitleColor: Colors.grey[400],
                  color: Colors.grey[200],
                  onPress: () async {},
                  shadow: null,
                  extend: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: true,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

var forumSettingsMsgPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return ForumSettingsMsgPage();
  },
);
