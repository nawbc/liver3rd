import 'package:flutter/material.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class SearchTopicsFragment extends StatefulWidget {
  final int gids;
  final String keyword;

  ///[type] 1 发送过的帖子 2 收藏
  const SearchTopicsFragment({
    Key key,
    this.gids,
    this.keyword,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SearchTopicsFragment();
  }
}

class _SearchTopicsFragment extends State<SearchTopicsFragment>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _refreshController = EasyRefreshController();
  ForumApi _forumApi = ForumApi();

  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  ScrollController _scrollController;
  Map _tmpData = {};
  List _topicList = [];
  bool _isLoadEmpty = false;
  User _user;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
  }

  Future<void> _onLoadTopic(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的话题'));
      return;
    }

    if (_loadPostLocker) {
      _loadPostLocker = false;
      var lastId = _tmpData['data']['last_id'];
      _forumApi
          .searchResult(
        2,
        gids: widget.gids,
        keyword: widget.keyword,
        lastId: lastId != null ? lastId.toString() : null,
      )
          .then((val) {
        _loadPostLocker = true;
        _tmpData = val;
        if (mounted) {
          setState(() {
            _topicList.addAll(val['data']['topic'] ?? []);
          });
        }
      });
    }

    if (_tmpData.isNotEmpty && _tmpData['data']['is_last']) {
      _postLastLocker = true;
    }
  }

  Future<void> _onRefreshPost(BuildContext context) async {
    _topicList = [];
    Map tmp = await _forumApi.searchResult(
      2,
      gids: widget.gids,
      keyword: widget.keyword,
    );

    _tmpData = tmp;
    List topic = tmp['data']['topics'];

    if (mounted) {
      setState(() {
        if (topic != null && topic.isNotEmpty) {
          _topicList.addAll(topic);
        } else {
          _isLoadEmpty = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(
        emptyWidget: _isLoadEmpty
            ? EmptyWidget(
                title: TextSnack['empty'],
              )
            : null,
        firstRefresh: true,
        scrollController: _scrollController,
        controller: _refreshController,
        header: BezierCircleHeader(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        footer: BezierBounceFooter(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        onLoad: () async {
          return _onLoadTopic(context);
        },
        onRefresh: () async {
          return _onRefreshPost(context);
        },
        slivers: _topicList.isEmpty
            ? [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container();
                  }, childCount: 1),
                )
              ]
            : [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Map topic = _topicList[index];

                      return UserProfileLabel(
                        onAvatarTap: (String heroTag) {
                          Navigate.navigate(
                            context,
                            '',
                            arg: {
                              // 'heroTag': heroTag,
                              // 'uid': currentPost['user']['uid'],
                            },
                          );
                        },
                        avatarUrl: topic['cover'],
                        nickName: topic['name'],
                        subTitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: screenWidth / 2,
                              child: NoScaledText(
                                topic['desc'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[300]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6),
                          ],
                        ),
                        extend: () {
                          return CommonWidget.button(
                            width: 60,
                            color: topic['is_focus']
                                ? Colors.grey[300]
                                : Colors.blue[200],
                            content: topic['is_focus'] ? '已关注' : '关注',
                            onPressed: () {
                              if (_user.isLogin) {
                                TinyUtils.followTopicOperate(
                                  topic['is_focus'],
                                  topic['id'],
                                  (val) {},
                                );
                              } else {
                                Navigate.navigate(context, 'login');
                              }
                            },
                          );
                        },
                      );
                    },
                    childCount: _topicList.length,
                  ),
                )
              ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
