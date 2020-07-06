import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class ForumSettingsFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForumSettingsFragmentState();
  }
}

class _ForumSettingsFragmentState extends State<ForumSettingsFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          OptionItem(
            title: '消息通知',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Navigate.navigate(context, 'settingmsg');
            },
            shadow: null,
            extend: Text('暂未实现', style: TextStyle(color: Colors.red)),
          ),
          OptionItem(
            title: '隐私',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Navigate.navigate(context, 'settingprivacy');
            },
            shadow: null,
          ),
          OptionItem(
            title: '账号编辑',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Navigate.navigate(context, 'accounteditor');
            },
            shadow: null,
          ),
          OptionItem(
            title: '注销账号',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Dialogs.showConfirmDialog(
                context,
                title: '注销账号',
                children: [Text('请联系: 021-34203305')],
                onCannel: () {
                  Navigator.pop(context);
                },
                onOk: () {
                  Navigator.pop(context);
                },
              );
            },
            shadow: null,
          ),
          OptionItem(
            title: '通行证',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Navigate.navigate(context, 'settingpassport');
            },
            shadow: null,
          ),
        ],
      ),
    );
  }
}
