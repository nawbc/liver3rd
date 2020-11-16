import 'package:flutter/material.dart';
import 'package:liver3rd/app/page/forum/more/block_page.dart';
import 'package:liver3rd/app/page/forum/more/follow_page.dart';
import 'package:liver3rd/app/page/forum/more/message_page.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:liver3rd/app/widget/sync_scroll_tabbar.dart';
import 'package:liver3rd/custom/badge/badge.dart';
import 'package:liver3rd/custom/badge/badge_animation_type.dart';
import 'package:liver3rd/custom/badge/badge_position.dart';
import 'package:liver3rd/custom/badge/badge_shape.dart';

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MorePageState();
  }
}

class _MorePageState extends State<MorePage> {
  GlobalKey<BadgeState> _key = GlobalKey<BadgeState>();

  List<Tab> _tabs;

  String handleMsgCount(int count) {
    return count >= 99 ? '99+' : '$count';
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      Tab(child: CommonWidget.tabTitle('关注')),
      Tab(child: CommonWidget.tabTitle('板块')),
      Tab(
        // key: _key,
        child: Badge(
          key: _key,
          badgeColor: Colors.blue[200],
          shape: BadgeShape.square,
          borderRadius: 30,
          animationType: BadgeAnimationType.scale,
          badgeContent: NoScaledText(handleMsgCount(100),
              style: TextStyle(color: Colors.white, fontSize: 12)),
          position: BadgePosition.topRight(),
          child: CommonWidget.tabTitle('消息'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SyncScrollTabBar(
      isScrollable: false,
      tabs: _tabs,
      onTap: (index) {
        _key.currentState.changeDisplay(false);
      },
      syncScrollableChildren: (controller) {
        return <Widget>[
          FollowPage(nestScrollController: controller),
          BlockPage(nestScrollController: controller),
          MessagePage(nestScrollController: controller),
        ];
      },
    );
  }
}
