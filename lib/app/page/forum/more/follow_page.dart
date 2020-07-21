import 'dart:async';

import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/widget/follow_user_card.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';


class FollowPage extends StatefulWidget {
  final ScrollController nestScrollController;

  const FollowPage({Key key, this.nestScrollController}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FollowPageState();
  }
}

class _FollowPageState extends State<FollowPage>
    with AutomaticKeepAliveClientMixin {
  SwiperController _swiperController = SwiperController();
  ScrollController _scrollController;

  ForumApi _forumApi = ForumApi();

  User _user;

  List _recommendUserList = [];
  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  bool _loadRecUserLocker = true;

  int _pageSize = 0;
  Map _tmpData = {};
  List _postList = [];
  List<Color> _colorList = [];

  @override
  void dispose() {
    super.dispose();
    _postList = [];
    _recommendUserList = [];
    _tmpData = {};
    _swiperController?.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        widget.nestScrollController.jumpTo(_scrollController.offset);
      });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    _refresh(context);
  }

  Future _loadRecUser() async {
    try {
      if (_loadRecUserLocker) {
        _loadRecUserLocker = false;
        _pageSize += 10;
        _forumApi
            .fetchRecommendActiveUserList(lastId: '0', pageSize: _pageSize)
            .then((tmp) {
          _loadRecUserLocker = true;
          _colorList.addAll(TinyUtils.randomColorList(10));
          if (mounted) {
            setState(() {
              _recommendUserList =
                  tmp['data'] != null ? tmp['data']['list'] : [];
            });
          }
        });
      }
    } catch (err) {
      FLog.error(
        className: "FollowPage",
        methodName: "_sendCode",
        text: "$err",
      );
      setState(() {
        _recommendUserList = [];
      });
    }
  }

  Future _loadPost(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有更多帖子'));
      return;
    }

    if (_loadPostLocker) {
      _loadPostLocker = false;
      _forumApi
          .fetchFollowerPost(
              lastId: _tmpData.isEmpty ? '' : _tmpData['data']['last_id'])
          .then((val) {
        _loadPostLocker = true;
        _tmpData = val;
        if (mounted) {
          setState(() {
            _postList.addAll(val['data']['list']);
          });
        }
      });
    }

    if (_tmpData.isNotEmpty && _tmpData['data']['is_last']) {
      _postLastLocker = true;
    }
  }

  Future _clear() async {
    _recommendUserList = [];
    _loadPostLocker = true;
    _postLastLocker = false;
    _loadRecUserLocker = true;
    _pageSize = 0;
    _tmpData = {};
    _postList = [];
  }

  Future _refresh(BuildContext context) async {
    _clear();
    if (_user.isLogin) {
      await _loadPost(context);
    }
    await _loadRecUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(
        scrollController: _scrollController,
        header: BezierCircleHeader(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        footer: BezierBounceFooter(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        onLoad: () async {
          if (_user.isLogin) await _loadPost(context);
        },
        onRefresh: () async {
          await _refresh(context);
        },
        slivers: <Widget>[
          _recommendUserList.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      height: screenWidth / (16 / 8) + 40,
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          TinyUtils.fixGestureConfliction(
                              details, _swiperController);
                        },
                        child: Swiper(
                          loop: false,
                          onIndexChanged: (index) async {
                            if (index == _recommendUserList.length - 2) {
                              await _loadRecUser();
                            }
                          },
                          itemBuilder: (BuildContext context, int sIndex) {
                            if (_recommendUserList.isEmpty) {
                              return Container();
                            } else {
                              Color randomColor = _colorList[sIndex];
                              Map userInfo = _recommendUserList[sIndex];
                              bool isFollowing = userInfo['is_follow'];
                              String uid = userInfo['uid'];

                              return FollowUserCard(
                                randomColor: randomColor,
                                name: userInfo['nickname'],
                                intro: userInfo['introduce'],
                                label: userInfo['certification']['label'],
                                type: userInfo['certification']['type'],
                                avatarUrl: userInfo['avatar_url'],
                                isFollow: isFollowing,
                                uid: uid,
                                onFollow: () async {},
                                onTap: (heroTag) {
                                  Navigate.navigate(context, 'userprofile',
                                      arg: {
                                        'heroTag': heroTag,
                                        'uid': userInfo['uid'],
                                      });
                                },
                              );
                            }
                          },
                          controller: _swiperController,
                          itemCount: _recommendUserList.length,
                          itemWidth: screenWidth - 50,
                          itemHeight: screenWidth / 2,
                          layout: SwiperLayout.STACK,
                          autoplay: true,
                          autoplayDelay: 6000,
                        ),
                      ),
                    );
                  }, childCount: 1),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      height: screenHeight - 200,
                      child: CommonWidget.loading(),
                    );
                  }, childCount: 1),
                ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _user.isLogin
                  ? Builder(
                      builder: (context) {
                        if (_postList.isEmpty) {
                          return Container();
                        } else {
                          Map post = _postList[index];
                          bool isUpvoted =
                              post['self_operation']['attitude'] == 1;
                          return PostBlock(
                            imgList: post['image_list'],
                            onTapUpvote: (isUpvoted) {
                              _forumApi.upvotePost(
                                postId: post['post_id'],
                                isCancel: !isUpvoted,
                              );
                            },
                            postContent: post['content'],
                            title: post['subject'],
                            stat: post['stat'],
                            topics: post['topics'],
                            isUpvoted: isUpvoted,
                            onImageTap: (i) {
                              Navigate.navigate(
                                context,
                                'photoviewpage',
                                arg: {
                                  'images': post['image_list'],
                                  'index': i,
                                },
                              );
                            },
                            onContentTap: () {
                              Navigate.navigate(context, 'post',
                                  arg: {'postId': post['post_id']});
                            },
                            headBlock: UserProfileLabel(
                              avatarUrl: post['user']['avatar_url'],
                              certificationType: post['user']['certification']
                                  ['type'],
                              createAt: post['created_at'],
                              level: post['user']['level_exp']['level'],
                              nickName: post['user']['nickname'],
                              onAvatarTap: (String heroTag) {
                                Navigate.navigate(
                                  context,
                                  'userprofile',
                                  arg: {
                                    'heroTag': heroTag,
                                    'uid': post['user']['uid'],
                                  },
                                );
                              },
                            ),
                          );
                        }
                      },
                    )
                  : EmptyWidget(
                      title: '点击登录',
                      onTap: () {
                        Navigate.navigate(context, "login");
                      },
                    );
            }, childCount: _postList.isEmpty ? 1 : _postList.length),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
