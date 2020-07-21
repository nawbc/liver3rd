import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/topic/topic_picture_fragment.dart';
import 'package:liver3rd/app/page/forum/topic/topic_post_fragment.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:liver3rd/custom/extended_nested_scroll_view/src/old_extended_nested_scroll_view.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class TopicFullTopicPage extends StatefulWidget {
  final int forumId;

  const TopicFullTopicPage({Key key, this.forumId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicFullTopicPageState();
  }
}

class _TopicFullTopicPageState extends State<TopicFullTopicPage> {
  TabController _tabController;
  ForumApi _forumApi = ForumApi();
  Map _topicData = {};
  double _expandedHeight = 190;
  int _sortType = 1;
  List<Tab> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = <Tab>[
      Tab(child: CommonWidget.tabTitle('最新')),
      Tab(child: CommonWidget.tabTitle('热门')),
      Tab(child: CommonWidget.tabTitle('精华'))
    ];
    _tabController =
        TabController(length: _tabs.length, vsync: ScrollableState());
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_topicData.isEmpty) {
      Map tmp = await _forumApi.fetchTopicFullInfo(widget.forumId);
      if (mounted) {
        setState(() {
          _topicData = tmp['data'] != null ? tmp['data'] : {};
        });
      }
    }
  }

  List<Widget> _resolveShowType() {
    int showType = _topicData['show_type'];

    switch (showType) {
      case 4:
        return <Widget>[
          TopicPictureFragment(
            usedHeight: _expandedHeight,
            sortType: _sortType,
          ),
          TopicPictureFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            // forumId: widget.forumId,
          ),
          TopicPictureFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
            // forumId: widget.forumId,
          ),
        ];
      case 1:
        return <Widget>[
          TopicPostFragment(
            usedHeight: _expandedHeight,
            sortType: _sortType,
            // forumId: widget.forumId,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            // forumId: widget.forumId,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
            // forumId: widget.forumId,
          ),
        ];
      default:
        return <Widget>[Container(), Container(), Container()];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _topicData.isEmpty
          ? Container(height: screenHeight, child: CommonWidget.loading())
          : NestedScrollView(
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).padding.top;
              },
              innerScrollPositionKeyBuilder: () {
                String index = 'topic_full_info';
                index += _tabController.index.toString();
                return Key(index);
              },
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    leading: CustomIcons.back(context, color: Colors.white),
                    expandedHeight: 190,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: CachedNetworkImage(
                                imageUrl: _topicData['topic']['cover'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: Opacity(
                                  opacity: 0.2,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints.expand(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[400]),
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
                          '${_topicData['topic']['name']}',
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
                            '简介: ${_topicData['topic']['desc']}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 5),
                      ]),
                    ),
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: screenWidth,
                        child: TabBar(
                          controller: _tabController,
                          indicatorPadding: EdgeInsets.all(0),
                          indicator: PointTabIndicator(
                            position: PointTabIndicatorPosition.bottom,
                            color: Colors.blue[200],
                            insets: EdgeInsets.only(bottom: 6),
                          ),
                          tabs: _tabs,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        TopicPostFragment(
                          usedHeight: _expandedHeight,
                          sortType: _sortType,
                          forumId: int.parse(_topicData['topic']['id']),
                          type: 1,
                        ),
                        TopicPostFragment(
                          usedHeight: _expandedHeight,
                          isHot: true,
                          sortType: _sortType,
                          forumId: int.parse(_topicData['topic']['id']),
                          type: 1,
                        ),
                        TopicPostFragment(
                          usedHeight: _expandedHeight,
                          isGood: true,
                          sortType: _sortType,
                          forumId: int.parse(_topicData['topic']['id']),
                          type: 1,
                        ),
                      ]
                          .asMap()
                          .map(
                            (index, child) {
                              return MapEntry(
                                index,
                                NestedScrollViewInnerScrollPositionKeyWidget(
                                  Key("topic_full_info$index"),
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

Handler topicFullInfoHandler = Handler(
  pageBuilder: (BuildContext context, arg) {
    return TopicFullTopicPage(
      forumId: arg['forumId'],
    );
  },
);
