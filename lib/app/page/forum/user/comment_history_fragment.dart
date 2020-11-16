import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/page/forum/widget/forum_comment_modal.dart';
import 'package:liver3rd/app/store/emojis.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/custom_modal_bottom_sheet.dart';
import 'package:liver3rd/app/widget/parse_emoji_text.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:provider/provider.dart';

class CommentHistoryBlock extends StatelessWidget {
  final String title;
  final String replyContent;
  final String postContent;
  final String createdTime;
  final Map emojis;
  final int floorId;
  final String postId;
  final String replyId;

  const CommentHistoryBlock(
      {Key key,
      this.title,
      this.createdTime,
      this.emojis,
      this.replyContent,
      this.postContent,
      this.floorId,
      this.postId,
      this.replyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isReplyComment = replyContent == null;
    return DefaultTextStyle(
      style: TextStyle(fontSize: 18, color: Colors.black38),
      child: Container(
        padding: EdgeInsets.all(15),
        width: width,
        height: 215,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text.rich(
              TextSpan(
                children: [
                  parseEmojiText(
                    emojis: emojis,
                    str: title,
                  )
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: width,
            height: 90,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  parseEmojiText(
                    emojis: emojis,
                    str: isReplyComment
                        ? '回复帖子: $postContent'
                        : '回复评论: $replyContent',
                    onPressed: () {
                      isReplyComment
                          ? Navigate.navigate(context, 'post',
                              arg: {'postId': postId})
                          : showCustomModalBottomSheet(
                              context: context,
                              child: ForumCommentModal(
                                postId: postId,
                                floorId: floorId,
                                replyId: replyId,
                              ),
                            );
                    },
                  )
                ],
              ),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: NoScaledText(createdTime),
          ),
        ]),
      ),
    );
  }
}

class CommentHistoryFragment extends StatefulWidget {
  final String uid;

  const CommentHistoryFragment({Key key, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentHistoryFragment();
  }
}

class _CommentHistoryFragment extends State<CommentHistoryFragment>
    with AutomaticKeepAliveClientMixin {
  UserApi _userApi = UserApi();

  bool _loadPostLocker = true;
  bool _postLastLocker = false;
  Map _tmpData = {};
  List _postList = [];
  Emojis _emoticonSet;
  bool _isLoadEmpty = false;
  bool _hasPermission = true;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_postList.isEmpty) {
      _onRefreshPost();
    }
  }

  @override
  initState() {
    super.initState();
    _emoticonSet = Provider.of<Emojis>(context, listen: false);
  }

  Future<void> _onLoadPost(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的帖子'));
      return;
    }

    if (_loadPostLocker) {
      _loadPostLocker = false;
      _userApi
          .fetchUserReplyList(
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
    Map tmp = await _userApi.fetchUserReplyList(uid: widget.uid);
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
      header: BezierCircleHeader(
        backgroundColor: Colors.white,
        color: Colors.blue[200],
      ),
      footer: BezierBounceFooter(
        backgroundColor: Colors.white,
        color: Colors.blue[200],
      ),
      emptyWidget: CommonWidget.noDataWidget(_isLoadEmpty, _hasPermission),
      onLoad: () {
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
                  Map comment = _postList[index];
                  return CommentHistoryBlock(
                    title: comment['content'],
                    replyContent: comment['f_reply']['content'],
                    postContent: comment['post']['subject'],
                    emojis: _emoticonSet.emojis['list_in_all'],
                    createdTime: comment['created_at'],
                    postId: comment['post']['post_id'],
                    replyId: comment['f_reply_id'],
                    floorId: comment['floor_id'] is String
                        ? int.parse(comment['floor_id'])
                        : comment['floor_id'],
                  );
                }, childCount: _postList.length),
              )
            ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
