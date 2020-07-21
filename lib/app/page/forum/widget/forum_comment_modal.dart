import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/widget/comment_block.dart';
import 'package:liver3rd/app/store/emojis.dart';

import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';

import 'package:provider/provider.dart';

class ForumCommentModal extends StatefulWidget {
  final String postId;
  final int floorId;
  final String replyId;

  const ForumCommentModal({Key key, this.postId, this.floorId, this.replyId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ForumCommentPageState();
  }
}

class _ForumCommentPageState extends State<ForumCommentModal> {
  ForumApi _forumApi = ForumApi();
  List _commentList = [];
  Map _commentData = {};
  Map _rootComment = {};
  Emojis _emoticonSet;
  // 等待加载完成 才能继续加载
  bool _loadCommentLocker = true;
  bool _lastLocker = false;

  @override
  void initState() {
    super.initState();
    _emoticonSet = Provider.of<Emojis>(context, listen: false);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_commentList.isEmpty || _rootComment.isEmpty) {
      await _onLoadComment(context, isInit: true);
    }
  }

  Future<void> _onLoadComment(BuildContext context,
      {bool isInit = false}) async {
    if (_lastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('评论以到底'));
      return;
    }

    Map rootTmp;
    if (isInit) {
      rootTmp = await _forumApi.fetchRootCommentInfo(
        postId: widget.postId,
        replyId: widget.replyId,
      );
    }

    if (_loadCommentLocker) {
      _loadCommentLocker = false;
      _forumApi
          .fetchPostSubComments(
        postId: widget.postId,
        floorId: widget.floorId,
        lastId: _commentData.isEmpty ? "0" : _commentData['data']['last_id'],
      )
          .then((tmp) {
        _loadCommentLocker = true;
        if (mounted) {
          setState(() {
            if (isInit) {
              _rootComment = rootTmp;
            }
            _commentData = tmp;
            _commentList.addAll(tmp['data']['list']);
          });
        }
      });

      if (_commentData.isNotEmpty &&
          _commentData['data']['is_last'] &&
          !isInit) {
        _lastLocker = true;
      }
    }
  }

  Widget _commentBlock(Map ele) {
    return CommentBlock(
      isUpvoted: ele['self_operation']['attitude'] == 1,
      partOfSubComments: ele['sub_replies'],
      reply: ele['reply'],
      replyTargetUser: ele['r_user'],
      likedNum: ele['stat']['like_num'],
      user: ele['user'],
      isLz: ele['is_lz'],
      onTapUpvote: (isUpvoted) {},
      onPressedFollow: () {},
      emojis: _emoticonSet.emojis['list_in_all'],
      subCommentsCount: ele['sub_reply_count'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: CommonWidget.titleText('${widget.floorId + 1}楼评论'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(36),
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return EasyRefresh.custom(
            header: BezierCircleHeader(
              backgroundColor: Colors.white,
              color: Colors.blue[200],
            ),
            footer: BezierBounceFooter(
              backgroundColor: Colors.white,
              color: Colors.blue[200],
            ),
            onLoad: () {
              return _onLoadComment(context);
            },
            // onRefresh: _onRefresh,
            slivers: (_commentList.isEmpty || _rootComment.isEmpty)
                ? <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: CommonWidget.loading(),
                        );
                      }, childCount: 1),
                    )
                  ]
                : <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return _commentBlock(_rootComment['data']['reply']);
                      }, childCount: 1),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Map ele = _commentList[index];
                        return _commentBlock(ele);
                      }, childCount: _commentList.length),
                    ),
                  ],
          );
        },
      ),
    );
  }
}
