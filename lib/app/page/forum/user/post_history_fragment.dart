import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class PostHistoryFragment extends StatefulWidget {
  final String uid;

  const PostHistoryFragment({
    Key key,
    this.uid,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PostHistoryFragment();
  }
}

class _PostHistoryFragment extends State<PostHistoryFragment>
    with AutomaticKeepAliveClientMixin {
  UserApi _userApi = UserApi();
  ForumApi _forumApi = ForumApi();
  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  bool _hasPermission = true;
  bool _isLoadEmpty = false;
  Map _tmpData = {};
  List _postList = [];

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_postList.isEmpty) {
      _onRefreshPost();
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
          .fetchUserPostList(
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
    Map tmp = await _userApi.fetchUserPostList(uid: widget.uid);
    _tmpData = tmp;
    if (tmp['data'] == null && tmp['retcode'] == 1001) {
      setState(() {
        _hasPermission = false;
      });
      return;
    }
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
      header: BezierCircleHeader(
        backgroundColor: Colors.white,
        color: Colors.blue[200],
      ),
      footer: BezierBounceFooter(
        backgroundColor: Colors.white,
        color: Colors.blue[200],
      ),
      emptyWidget: CommonWidget.noDataWidget(_isLoadEmpty, _hasPermission),
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
                  Map post = _postList[index];
                  bool isUpvoted = post['self_operation']['attitude'] == 1;
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
                    headBlock: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15, bottom: 15),
                      child: NoScaledText(
                        post['created_at'],
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
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
