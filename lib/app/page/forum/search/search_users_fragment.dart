import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/store/global_model.dart';

import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';

import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class SearchUsersFragment extends StatefulWidget {
  final int gids;
  final String keyword;

  ///[type] 1 发送过的帖子 2 收藏

  const SearchUsersFragment({
    Key key,
    this.gids,
    this.keyword,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SearchUsersFragment();
  }
}

class _SearchUsersFragment extends State<SearchUsersFragment>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _refreshController = EasyRefreshController();
  ForumApi _forumApi = ForumApi();

  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  ScrollController _scrollController;
  Map _tmpData = {};
  List _userList = [];
  bool _isLoadEmpty = false;
  GlobalModel _globalModel;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);
  }

  Future<void> _onLoadUser(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的话题'));
      return;
    }

    if (_loadPostLocker) {
      var lastId = _tmpData['data']['last_id'];
      _loadPostLocker = false;
      _forumApi
          .searchResult(
        3,
        gids: widget.gids,
        keyword: widget.keyword,
        lastId: lastId != null ? lastId.toString() : null,
      )
          .then((val) {
        _loadPostLocker = true;
        _tmpData = val;
        if (mounted) {
          setState(() {
            _userList.addAll(val['data']['users'] ?? []);
          });
        }
      });
    }

    if (_tmpData.isNotEmpty && _tmpData['data']['is_last']) {
      _postLastLocker = true;
    }
  }

  Future<void> _onRefreshPost(BuildContext context) async {
    _userList = [];
    Map tmp = await _forumApi.searchResult(
      3,
      gids: widget.gids,
      keyword: widget.keyword,
    );

    _tmpData = tmp;
    List user = tmp['data']['users'];
    if (mounted) {
      setState(() {
        if (user != null && user.isNotEmpty) {
          _userList.addAll(user);
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
          return _onLoadUser(context);
        },
        onRefresh: () async {
          return _onRefreshPost(context);
        },
        slivers: _userList.isEmpty
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
                      Map user = _userList[index];

                      return UserProfileLabel(
                        onAvatarTap: (String heroTag) {
                          Navigate.navigate(
                            context,
                            'userprofile',
                            arg: {
                              'heroTag': heroTag,
                              'uid': user['uid'],
                            },
                          );
                        },
                        avatarUrl: user['avatar_url'],
                        nickName: user['nickname'],
                        subTitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: screenWidth / 2,
                              child: NoScaledText(
                                user['introduce'],
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
                            color: user['is_following']
                                ? Colors.grey[300]
                                : Colors.blue[200],
                            content: user['is_following'] ? '已关注' : '关注',
                            onPressed: () {
                              if (_globalModel.isLogin) {
                                TinyUtils.followTopicOperate(
                                  user['is_following'],
                                  user['id'],
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
                    childCount: _userList.length,
                  ),
                )
              ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
