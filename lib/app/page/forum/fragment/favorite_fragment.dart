import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/post_api.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class FavoriteFragment extends StatefulWidget {
  final String uid;

  const FavoriteFragment({Key key, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavoriteFragmentState();
  }
}

class _FavoriteFragmentState extends State<FavoriteFragment>
    with AutomaticKeepAliveClientMixin {
  User _user;
  UserApi _userApi = UserApi();
  PostApi _postApi = PostApi();
  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  ScrollController _scrollController;
  Map _tmpData = {};
  List _postList = [];
  bool _isLoadEmpty = false;
  bool _hasPermission = true;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    if (_postList.isEmpty) {
      await _onRefreshPost();
    }
  }

  Future<void> _onLoadPost(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的帖子'));
      return;
    }

    if (_loadPostLocker) {
      _loadPostLocker = false;
      _userApi
          .fetchUserFavoritePostList(
              uid: widget.uid, lastId: _tmpData['data']['last_id'])
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

  Future<void> _onRefreshPost() async {
    _postList = [];
    Map tmp = await _userApi.fetchUserFavoritePostList(
      uid: widget.uid,
      lastId: _tmpData.isNotEmpty ? _tmpData['data']['last_id'] : '-1',
    );

    if (tmp['data'] == null && tmp['retcode'] == 1001) {
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    _tmpData = tmp;
    List posts = tmp['data']['list'];

    if (mounted) {
      setState(() {
        if (posts != null && posts.isNotEmpty) {
          _postList.addAll(posts);
        } else {
          _isLoadEmpty = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      firstRefresh: false,
      emptyWidget: CommonWidget.noDataWidget(_isLoadEmpty, _hasPermission),
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
        return _onLoadPost(context);
      },
      onRefresh: _onRefreshPost,
      slivers: _postList.isEmpty
          ? [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    height: 200,
                    child: CommonWidget.loading(),
                  );
                }, childCount: 1),
              )
            ]
          : [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map post = _postList[index]['post'];
                  bool isUpvoted = post['self_operation']['attitude'] == 1;
                  return PostBlock(
                    imgList: post['image_list'],
                    onTapUpvote: (isCancel) async {
                      if (_user.isLogin) {
                        await _postApi.upvotePost(
                          postId: post['post']['post_id'],
                          isCancel: isCancel,
                        );
                      } else {
                        Navigate.navigate(context, 'login');
                      }
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
                      certificationType: post['user']['certification']['type'],
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
                }, childCount: _postList.length),
              )
            ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
