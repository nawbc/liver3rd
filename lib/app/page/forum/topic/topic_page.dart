import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/topic/topic_faq_fragment.dart';
import 'package:liver3rd/app/page/forum/topic/topic_news_fragment.dart';
import 'package:liver3rd/app/page/forum/topic/topic_picture_fragment.dart';
import 'package:liver3rd/app/page/forum/topic/topic_post_fragment.dart';
import 'package:liver3rd/app/page/forum/topic/topic_type_0.dart';
import 'package:liver3rd/app/page/forum/topic/topic_type_1.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class TopicPage extends StatefulWidget {
  final int forumId;
  final int srcType;

  const TopicPage({Key key, this.forumId, this.srcType}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TopicPageState();
  }
}

class _TopicPageState extends State<TopicPage>
    with AutomaticKeepAliveClientMixin {
  ForumApi _forumApi = ForumApi();
  double _expandedHeight = 190;
  Map _topicData = {};
  int _sortType = 1;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (_topicData.isEmpty) {
      Map tmp = await _forumApi.fetchForumMain(forumId: widget.forumId);
      if (mounted) {
        setState(() {
          _topicData = tmp['data'] != null ? tmp['data'] : {};
        });
      }
    }
  }

  List<Widget> _topic0ShowType() {
    int showType = _topicData['show_type'];

    switch (showType) {
      case 4:
        return <Widget>[
          TopicPictureFragment(
            usedHeight: _expandedHeight,
            sortType: _sortType,
            forumId: widget.forumId,
          ),
          TopicPictureFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            forumId: widget.forumId,
          ),
          TopicPictureFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
            forumId: widget.forumId,
          ),
        ];
      case 1:
        return <Widget>[
          TopicPostFragment(
            usedHeight: _expandedHeight,
            sortType: _sortType,
            forumId: widget.forumId,
            type: 0,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            type: 0,
            forumId: widget.forumId,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
            type: 0,
            forumId: widget.forumId,
          ),
        ];
      case 5:
        return <Widget>[
          TopicPostFragment(
            usedHeight: _expandedHeight,
            sortType: _sortType,
            forumId: widget.forumId,
            type: 0,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            type: 0,
            forumId: widget.forumId,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
            type: 0,
            forumId: widget.forumId,
          ),
        ];
      case 6:
        return <Widget>[
          TopicPostFragment(
            usedHeight: _expandedHeight,
            sortType: _sortType,
            forumId: widget.forumId,
            type: 0,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            type: 0,
            forumId: widget.forumId,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
            type: 0,
            forumId: widget.forumId,
          ),
        ];
      default:
        return <Widget>[Container(), Container(), Container()];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget topic;

    switch (widget.srcType) {
      case 0:
        topic = TopicType0(
          sortType: _sortType,
          onSortButtonPressed: (type) {
            setState(() {
              _sortType = type == 1 ? 2 : 1;
            });
          },
          headerImage: _topicData.isNotEmpty ? _topicData['header_image'] : '',
          name: _topicData.isNotEmpty ? _topicData['name'] : '',
          introduce: (_topicData.isNotEmpty
              ? _topicData['des']
              : NO_SIGNNATURE_STRING),
          topicData: _topicData,
          tabs: <Tab>[
            Tab(child: CommonWidget.tabTitle('最新')),
            Tab(child: CommonWidget.tabTitle('热门')),
            Tab(child: CommonWidget.tabTitle('精华')),
          ],
          expandedHeight: _expandedHeight,
          tabViews: _topic0ShowType(),
        );
        break;
      case 1:
        topic = TopicType1(
          name: _topicData.isNotEmpty ? _topicData['name'] : '',
          tabs: <Tab>[
            Tab(child: CommonWidget.tabTitle('最新')),
            Tab(child: CommonWidget.tabTitle('热门')),
            Tab(child: CommonWidget.tabTitle('推荐')),
          ],
          tabViews: <Widget>[
            TopicFaqFragment(
              usedHeight: _expandedHeight,
              forumId: widget.forumId,
            ),
            TopicFaqFragment(
              usedHeight: _expandedHeight,
              isHot: true,
              forumId: widget.forumId,
            ),
            TopicFaqFragment(
              usedHeight: _expandedHeight,
              isGood: true,
              forumId: widget.forumId,
            ),
          ],
        );
        break;
      case 2:
        topic = TopicType1(
          name: _topicData.isNotEmpty ? _topicData['name'] : '',
          tabs: <Tab>[
            Tab(child: CommonWidget.tabTitle('活动')),
            Tab(child: CommonWidget.tabTitle('公告')),
            Tab(child: CommonWidget.tabTitle('咨询')),
          ],
          tabViews: <Widget>[
            TopicNewsFragment(
              usedHeight: _expandedHeight,
              type: 2,
            ),
            TopicNewsFragment(
              usedHeight: _expandedHeight,
              type: 1,
            ),
            TopicNewsFragment(
              usedHeight: _expandedHeight,
              type: 3,
            ),
          ],
        );
        break;
      default:
        topic = Scaffold(
          backgroundColor: Colors.transparent,
          body: EmptyWidget(title: '出错'),
        );
    }

    return topic;
  }

  @override
  bool get wantKeepAlive => true;
}

Handler topicPageHandler = Handler(pageBuilder: (BuildContext context, args) {
  return TopicPage(
    forumId: args['forum_id'],
    srcType: args['src_type'],
  );
});
