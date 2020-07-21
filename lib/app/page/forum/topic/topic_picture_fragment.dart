import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/topic/topic_image_card.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class TopicPictureFragment extends StatefulWidget {
  final double usedHeight;
  final bool isGood;
  final bool isHot;
  final int sortType;
  final int forumId;

  const TopicPictureFragment(
      {Key key,
      this.usedHeight,
      this.isGood = false,
      this.isHot = false,
      this.sortType = 1,
      this.forumId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TopicFragmentState();
  }
}

class TopicFragmentState extends State<TopicPictureFragment>
    with AutomaticKeepAliveClientMixin {
  ForumApi _forumApi = ForumApi();
  Map _tmpData = {};
  List _postList = [];
  int _tmpSortType = 1;

  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  User _user;

  didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    if (_postList.isEmpty) {
      await _refresh();
    }
  }

  Future<void> _refresh() async {
    _postList = [];
    Map tmp = await _forumApi.fetchForumPostList(
        forumId: widget.forumId,
        isGood: widget.isGood,
        isHot: widget.isHot,
        sortType: widget.sortType,
        lastId: "");
    List posts = tmp['data']['list'];
    _tmpData = tmp;
    if (mounted) {
      setState(() {
        if (posts != null && posts.isNotEmpty) {
          _postList.addAll(posts);
        }
      });
    }
  }

  Future<void> _onLoadPost(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的小h图片'));
      return;
    }

    if (_loadPostLocker) {
      _loadPostLocker = false;

      _forumApi
          .fetchForumPostList(
        forumId: widget.forumId,
        isGood: widget.isGood,
        isHot: widget.isHot,
        sortType: widget.sortType,
        lastId: _tmpData['data']['last_id'],
      )
          .then((val) {
        _loadPostLocker = true;
        _tmpData = val;
        if (mounted) {
          setState(() {
            _postList.addAll(val['data']['list'] ?? []);
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
    _postList = [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;

    if (_tmpSortType != widget.sortType) {
      _refresh();
      _tmpSortType = widget.sortType;
    }

    return EasyRefresh.custom(
      header: BezierCircleHeader(
          backgroundColor: Colors.white, color: Colors.blue[200]),
      footer: BezierBounceFooter(
          backgroundColor: Colors.white, color: Colors.blue[200]),
      onLoad: () async {
        _onLoadPost(context);
      },
      onRefresh: _refresh,
      slivers: _postList.isEmpty
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
                    Map post = _postList[index];
                    Map safeImg = (post['image_list'] is List &&
                            post['image_list'].isNotEmpty)
                        ? (post['image_list'][0] ??
                            {'width': 1, 'height': 1, 'url': ''})
                        : {'width': 1, 'height': 1, 'url': ''};
                    return TopicImageCard(
                      onTap: () {
                        Navigate.navigate(context, 'post', arg: {
                          'postId': post['post']['post_id'],
                        });
                      },
                      onTapAvatar: (heroTag) {
                        Navigate.navigate(context, 'userprofile', arg: {
                          'uid': post['user']['uid'],
                          'heroTag': heroTag
                        });
                      },
                      onTapUpvote: (_isUpvote) {
                        if (_user.isLogin) {
                          return true;
                        } else {
                          Navigate.navigate(context, 'login');
                          return false;
                        }
                      },
                      nickName: post['user']['nickname'],
                      avatarUrl: post['user']['avatar_url'],
                      introduce: post['post']['content'],
                      coverUrl: TinyUtils.thumbnailUrl(safeImg['url'] ?? ''),
                      imgRate: safeImg['height'] / safeImg['width'],
                      likeNum: post['stat']['like_num'],
                    );
                  },
                  childCount: _postList.length,
                ),
              ),
            ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
