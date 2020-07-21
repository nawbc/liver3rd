import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:liver3rd/custom/extended_nested_scroll_view/src/old_extended_nested_scroll_view.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class TopicType0 extends StatefulWidget {
  final List<Widget> tabViews;
  final double expandedHeight;
  final List<Tab> tabs;
  final int forumId;
  final dynamic headerImage;
  final String introduce;
  final Map topicData;
  final String name;
  final Function(int) onSortButtonPressed;
  final int sortType;
  final int type;

  const TopicType0({
    Key key,
    this.tabViews,
    this.expandedHeight,
    this.tabs,
    this.forumId,
    this.headerImage,
    this.introduce,
    this.topicData,
    this.name,
    this.onSortButtonPressed,
    this.sortType = 1,
    this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicType0();
  }
}

class _TopicType0 extends State<TopicType0> {
  TabController _tabController;
  double _topItemHeight = 50;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabs.length, vsync: ScrollableState());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top;
        },
        innerScrollPositionKeyBuilder: () {
          String index = 'topic_tab';
          index += _tabController.index.toString();
          return Key(index);
        },
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              leading: CustomIcons.back(context, color: Colors.white),
              expandedHeight: widget.expandedHeight,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: widget.headerImage != ''
                            ? CachedNetworkImage(
                                imageUrl: TinyUtils.thumbnailUrl(
                                    widget.headerImage ?? ''),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(coverbgPath, fit: BoxFit.cover),
                      ),
                      Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Opacity(
                            opacity: 0.2,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.grey[400]),
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                titlePadding: EdgeInsets.only(),
                centerTitle: true,
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Column(children: [
                  Text(
                    widget.name,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(height: 8),
                  CommonWidget.button(
                    width: 50,
                    height: 30,
                    onPressed: () {},
                    child: Text(
                      '关注',
                      style: TextStyle(fontSize: 14),
                    ),
                    // height:
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: screenWidth - 60,
                    child: Text(
                      '简介: ' + widget.introduce,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  if (widget.topicData.isNotEmpty &&
                      widget.topicData['topics'] != null)
                    Container(
                      width: screenWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(right: 15, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: widget.topicData['topics']
                              .map<Widget>(
                                (val) => Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigate.navigate(context, 'topicinfo',
                                          arg: {'forumId': val['id']});
                                    },
                                    child: Chip(
                                      label: Text(
                                        '${val['name']}',
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  SizedBox(height: 5),
                ]),
              ),
            ),
            if (widget.topicData['top_posts'] != null &&
                widget.topicData['top_posts'].isNotEmpty) ...[
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                    maxHeight: 15, minHeight: 15, child: Container()),
              ),
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  maxHeight: _topItemHeight + 30,
                  minHeight: _topItemHeight + 30,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    itemCount: widget.topicData['top_posts'].length,
                    itemBuilder: (context, index) {
                      var post = widget.topicData['top_posts'][index];
                      return Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: InkWell(
                          onTap: () {
                            Navigate.navigate(
                              context,
                              'post',
                              arg: {'postId': post['post_id']},
                            );
                          },
                          child: OptionItem(
                            outSidePadding: 70,
                            height: _topItemHeight,
                            subTitle: post['subject'],
                            color: Colors.white,
                            subTitleColor: Colors.grey,
                            extend: CommonWidget.button(
                              elevation: 0,
                              width: 40,
                              height: 26,
                              onPressed: () {},
                              child: Text('顶置'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                    maxHeight: 20, minHeight: 20, child: Container()),
              )
            ]
          ];
        },
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: screenWidth - 100,
                  child: TabBar(
                    controller: _tabController,
                    indicatorPadding: EdgeInsets.all(0),
                    indicator: PointTabIndicator(
                      position: PointTabIndicatorPosition.bottom,
                      color: Colors.blue[200],
                      insets: EdgeInsets.only(bottom: 6),
                    ),
                    tabs: widget.tabs,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CommonWidget.button(
                    width: 70,
                    height: 30,
                    onPressed: () {
                      widget.onSortButtonPressed(widget.sortType);
                    },
                    child: Text(
                      widget.sortType == 1 ? '按发帖顺序' : '按时间顺序',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.tabViews
                    .asMap()
                    .map(
                      (index, child) {
                        return MapEntry(
                          index,
                          NestedScrollViewInnerScrollPositionKeyWidget(
                            Key("topic_tab$index"),
                            child,
                          ),
                        );
                      },
                    )
                    .values
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
