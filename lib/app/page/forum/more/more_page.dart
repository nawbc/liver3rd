import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/page/forum/more/block_page.dart';
import 'package:liver3rd/app/page/forum/more/follow_page.dart';
import 'package:liver3rd/app/page/forum/more/message_page.dart';
import 'package:liver3rd/app/page/forum/send_post_page.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
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
  TabController _tabController;
  List<Tab> _tabList;

  String handleMsgCount(int count) {
    return count >= 99 ? '99+' : '$count';
  }

  @override
  void initState() {
    super.initState();
    _tabList = [
      Tab(
        child: NoScaledText(
          '关注',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
      Tab(
        child: NoScaledText(
          '板块',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
      Tab(
        child: NoScaledText(
          '发帖',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
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
          child: NoScaledText(
            '消息',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      ),
    ];
    _tabController = TabController(
      length: _tabList.length,
      vsync: ScrollableState(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: TabBar(
          tabs: _tabList,
          controller: _tabController,
          indicatorPadding: EdgeInsets.all(0),
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorHeight: 30.0,
            indicatorColor: Colors.blue[200],
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FollowPage(),
          BlockPage(),
          SendPostPage(),
          MessagePage(),
        ],
      ),
    );

    // SyncScrollTabBar(
    //   isScrollable: false,
    //   tabs: _tabs,
    //   onTap: (index) {
    //     _key.currentState.changeDisplay(false);
    //   },
    //   syncScrollableChildren: (controller) {
    //     return <Widget>[

    //     ];
    //   },
    // );
  }
}
