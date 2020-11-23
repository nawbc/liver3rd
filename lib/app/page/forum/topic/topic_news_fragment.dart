import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/widget/card_news.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class TopicNewsFragment extends StatefulWidget {
  final double usedHeight;
  final int type;
  final int forumId;

  const TopicNewsFragment(
      {Key key, this.usedHeight, this.type = 1, this.forumId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TopicNewsFragmentState();
  }
}

class _TopicNewsFragmentState extends State<TopicNewsFragment>
    with AutomaticKeepAliveClientMixin {
  ForumApi _forumApi = ForumApi();
  Map _tmpData = {};
  List _newsList = [];

  bool _loadPostLocker = true;
  bool _postLastLocker = false;

  didChangeDependencies() async {
    super.didChangeDependencies();

    if (_newsList.isEmpty) {
      await _refresh();
    }
  }

  Future<void> _refresh() async {
    _newsList = [];
    Map tmp = await _forumApi.fetchNewsList(type: widget.type, lastId: 0);
    List news = tmp['data']['list'];
    _tmpData = tmp;
    if (mounted) {
      setState(() {
        if (news != null && news.isNotEmpty) {
          _newsList.addAll(news);
        }
      });
    }
  }

  Future<void> _onLoadPost(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的帖子'));
      return;
    }

    if (_loadPostLocker) {
      _loadPostLocker = false;

      _forumApi
          .fetchNewsList(
        type: widget.type,
        lastId: _tmpData['data']['last_id'],
      )
          .then((val) {
        _loadPostLocker = true;
        _tmpData = val;
        if (mounted) {
          setState(() {
            _newsList.addAll(val['data']['list'] ?? []);
          });
        }
      });
    }

    if (_tmpData.isNotEmpty && _tmpData['data']['is_last']) {
      _postLastLocker = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newsList = [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return EasyRefresh.custom(
      header: BezierCircleHeader(
          backgroundColor: Colors.white, color: Colors.blue[200]),
      footer: BezierBounceFooter(
          backgroundColor: Colors.white, color: Colors.blue[200]),
      onLoad: () async {
        _onLoadPost(context);
      },
      onRefresh: _refresh,
      slivers: _newsList.isEmpty
          ? <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      height: screenHeight - widget.usedHeight,
                      child: CommonWidget.loading(),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ]
          : <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Map news = _newsList[index];

                    return CardNews(
                      onTap: () {
                        Navigate.navigate(context, 'post',
                            arg: {'postId': news['post']['post_id']});
                      },
                      content: news['post']['subject'],
                      imgUrl: news['post']['images'].isEmpty
                          ? null
                          : news['post']['images'][0],
                    );
                  },
                  childCount: _newsList.length,
                ),
              ),
            ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
