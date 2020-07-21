import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';

class TopicType1 extends StatefulWidget {
  final List<Widget> tabViews;
  final List<Tab> tabs;
  final int forumId;
  final Map topicData;
  final String name;
  final int type;

  const TopicType1({
    Key key,
    this.tabViews,
    this.tabs,
    this.forumId,
    this.topicData,
    this.name,
    this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicType1();
  }
}

class _TopicType1 extends State<TopicType1> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabs.length, vsync: ScrollableState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidget.titleText(widget.name),
        centerTitle: true,
        leading: CustomIcons.back(context),
        elevation: 0,
        bottom: TabBar(
          tabs: widget.tabs,
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
      body: TabBarView(controller: _tabController, children: widget.tabViews),
    );
  }
}
