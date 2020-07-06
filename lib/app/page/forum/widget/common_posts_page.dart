import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:liver3rd/app/api/forum/post_api.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';

import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class CommonPostsPage extends StatefulWidget {
  final Future<Map> Function(Map data) fetchData;
  final bool useRefresh;
  final String listProp;
  final bool usingAutoRefresh;
  final Widget loadingWidgetNotAutoRefresh;

  ///[type] 1 发送过的帖子 2 收藏

  const CommonPostsPage({
    Key key,
    this.fetchData,
    this.useRefresh,
    this.listProp = 'posts',
    this.usingAutoRefresh = true,
    this.loadingWidgetNotAutoRefresh,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CommonPostsPage();
  }
}

class _CommonPostsPage extends State<CommonPostsPage>
    with AutomaticKeepAliveClientMixin {
  PostApi _postApi = PostApi();
  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  ScrollController _scrollController;
  Map _tmpData = {};
  List _postList = [];
  bool _isLoadEmpty = false;
  User _user;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    if (_postList.isEmpty && !widget.usingAutoRefresh) {
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
      widget.fetchData(_tmpData).then((val) {
        _loadPostLocker = true;
        _tmpData = val;
        if (mounted) {
          setState(() {
            _postList.addAll(val['data'][widget.listProp] ?? []);
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
    Map tmp = await widget.fetchData(_tmpData);

    _tmpData = tmp;
    List posts = tmp['data'][widget.listProp];

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
      firstRefresh: widget.usingAutoRefresh,
      emptyWidget: _isLoadEmpty
          ? EmptyWidget(
              title: TextSnack['empty'],
            )
          : null,
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
                  return widget.usingAutoRefresh
                      ? Container()
                      : widget.loadingWidgetNotAutoRefresh;
                }, childCount: 1),
              )
            ]
          : [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  Map post = _postList[index];
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
                    postContent: post['post']['content'],
                    title: post['post']['subject'],
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
                          arg: {'postId': post['post']['post_id']});
                    },
                    headBlock: UserProfileLabel(
                      avatarUrl: post['user']['avatar_url'],
                      certificationType: post['user']['certification']['type'],
                      createAt: post['post']['created_at'],
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
