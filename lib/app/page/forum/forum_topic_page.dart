import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/forum/post_api.dart';
import 'package:liver3rd/app/page/forum/fragment/topic_picture_fragment.dart';
import 'package:liver3rd/app/page/forum/fragment/topic_post_fragment.dart';
import 'package:liver3rd/app/page/forum/widget/topic_page_frame.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class ForumTopicPage extends StatefulWidget {
  final int forumId;

  const ForumTopicPage({Key key, this.forumId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ForumPictureTopicPageState();
  }
}

class _ForumPictureTopicPageState extends State<ForumTopicPage>
    with AutomaticKeepAliveClientMixin {
  PostApi _postApi = PostApi();
  Map _topicData = {};
  double _expandedHeight = 190;
  int _sortType = 1;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (_topicData.isEmpty) {
      Map tmp = await _postApi.fetchForumMain(forumId: widget.forumId);
      setState(() {
        _topicData = tmp['data'] != null ? tmp['data'] : {};
      });
    }
  }

  List<Widget> _resolveShowType() {
    int showType = _topicData['show_type'];
    print(showType);
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
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isHot: true,
            sortType: _sortType,
            forumId: widget.forumId,
          ),
          TopicPostFragment(
            usedHeight: _expandedHeight,
            isGood: true,
            sortType: _sortType,
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

    return TopicPageFrame(
      sortType: _sortType,
      onSortButtonPressed: (type) {
        setState(() {
          _sortType = type == 1 ? 2 : 1;
        });
      },
      headerImage: _topicData.isNotEmpty ? _topicData['header_image'] : '',
      name: _topicData.isNotEmpty ? _topicData['name'] : '',
      introduce:
          (_topicData.isNotEmpty ? _topicData['des'] : NO_SIGNNATURE_STRING),
      topicData: _topicData,
      tabs: <Tab>[
        Tab(child: CommonWidget.tabTitle('最新')),
        Tab(child: CommonWidget.tabTitle('热门')),
        Tab(child: CommonWidget.tabTitle('精华')),
      ],
      expandedHeight: _expandedHeight,
      tabViews: _resolveShowType(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Handler forumTopicPageHandler =
    Handler(pageBuilder: (BuildContext context, args) {
  return ForumTopicPage(
    forumId: args['forum_id'],
  );
});
