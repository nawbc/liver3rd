import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class OtherSettingsFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OtherSettingsFragmentState();
  }
}

class _OtherSettingsFragmentState extends State<OtherSettingsFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          OptionItem(
            title: '打赏',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Navigate.navigate(context, 'inapppurchase');
            },
            shadow: null,
          ),
          OptionItem(
            title: '关于',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              Navigate.navigate(context, 'about');
            },
            shadow: null,
          ),
        ],
      ),
    );
  }
}
