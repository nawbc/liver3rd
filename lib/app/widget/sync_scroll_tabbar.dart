import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:liver3rd/app/widget/common_widget.dart';

class SyncScrollTabBar extends StatefulWidget {
  final List<Widget> Function(ScrollController controller)
      syncScrollableChildren;
  final List<String> tabTitles;
  final List<Widget> tabs;
  final Function(int) onTap;

  final bool isScrollable;

  const SyncScrollTabBar(
      {Key key,
      this.syncScrollableChildren,
      this.tabTitles,
      this.tabs,
      this.onTap,
      this.isScrollable = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SyncScrollTabBarState();
  }
}

class _SyncScrollTabBarState extends State<SyncScrollTabBar> {
  TabController _controller;
  ScrollController _nestController;

  List<Tab> _tabList;
  @override
  void initState() {
    super.initState();
    if (widget.tabTitles == null) {
      _tabList = widget.tabs;
    } else {
      _tabList = widget.tabTitles.map((val) {
        return Tab(child: CommonWidget.tabTitle(val));
      }).toList();
    }
    _nestController = ScrollController();
    _controller = TabController(
      length: _tabList.length,
      vsync: ScrollableState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _nestController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              forceElevated: false,
              elevation: 0,
              title: TabBar(
                onTap: widget.onTap,
                tabs: _tabList,
                controller: _controller,
                indicatorPadding: EdgeInsets.all(0),
                isScrollable: true,
                indicator: PointTabIndicator(
                  position: PointTabIndicatorPosition.bottom,
                  color: Colors.blue[200],
                  insets: EdgeInsets.only(bottom: 6),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _controller,
          physics: widget.isScrollable
              ? ScrollPhysics()
              : NeverScrollableScrollPhysics(),
          children: widget.syncScrollableChildren(_nestController),
        ),
      ),
    );
  }
}
