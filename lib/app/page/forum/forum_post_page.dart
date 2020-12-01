import 'dart:convert';

import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/widget/comment_block.dart';
import 'package:liver3rd/app/page/forum/widget/self_rich_text.dart';
import 'package:liver3rd/app/page/forum/widget/self_rich_text_html.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/reply_modal.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class ForumPostPage extends StatefulWidget {
  final String postId;
  const ForumPostPage({Key key, this.postId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ForumPostPageState();
  }
}

class _ForumPostPageState extends State<ForumPostPage> {
  String _heroTag = 'speed-dial-hero-tag';
  GlobalModel _globalModel;
  Map _postData = {};
  Map _commentData = {};
  List _commentList = [];
  // 等待加载完成 才能继续加载
  bool _loadCommentLocker = true;
  bool _commentLastLocker = false;
  bool _isHtmlPostContent = false;
  ForumApi _forumApi = ForumApi();
  EasyRefreshController _controller = EasyRefreshController();

  @override
  initState() {
    super.initState();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);

    if (_postData.isEmpty) {
      Map tmp = await _forumApi.fetchFullPost(widget.postId);
      if (mounted) {
        setState(() {
          _postData = tmp;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _forumApi = null;
    _postData = {};
    _commentData = {};
    _commentList = [];
  }

  bool _isHtmlTag(String str) {
    return RegExp('(<\/?[a-zA-Z]+([^]*|[^]*|[^>])*>)|(&[a-zA-Z\\d]+);')
        .hasMatch(str);
  }

  Widget _labelWidget(String content) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: NoScaledText(
        content,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _commentData = {};
    _commentList = [];
    _postData = {};

    Map tmp = await _forumApi.fetchFullPost(widget.postId);
    if (mounted) {
      setState(() {
        _postData = tmp;
      });
    }
  }

  Future<void> _onLoadComment(BuildContext context) async {
    if (_commentLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('评论以到底'));
      return;
    }

    if (_loadCommentLocker) {
      _loadCommentLocker = false;
      _forumApi
          .fetchPostComment(
        postId: widget.postId,
        lastId: _commentData.isEmpty ? "0" : _commentData['data']['last_id'],
      )
          .then((tmp) {
        _loadCommentLocker = true;
        if (mounted) {
          setState(() {
            _commentData = tmp;
            _commentList.addAll(tmp['data']['list']);
          });
        }
      });

      if (_commentData.isNotEmpty && _commentData['data']['is_last']) {
        _commentLastLocker = true;
      }
    }
  }

  String _topTitle() {
    if (_postData.isEmpty) {
      return '';
    } else {
      Map forum = _postData['data']['post']['forum'];
      int id = _postData['data']['post']['game_id'];
      return forum == null ? _globalModel.gameList[id]['name'] : forum['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: PreferredSize(
            child: AppBar(
              title: CommonWidget.titleText(_topTitle()),
              centerTitle: true,
              leading: CustomIcons.back(context),
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(36),
          ),
          backgroundColor: Colors.white,
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            visible: true,
            curve: Curves.bounceIn,
            onOpen: () {},
            onClose: () {},
            heroTag: _heroTag,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.create),
                backgroundColor: Colors.blue[200],
                labelWidget: _labelWidget('评论'),
                onTap: () {
                  showBottomReply(context, onSend: (text) {
                    print(text);
                  });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.favorite),
                backgroundColor: Colors.pink,
                labelWidget: _labelWidget(_postData.isEmpty
                    ? ''
                    : '${_postData['data']['post']['stat']['like_num']}'),
                onTap: () => print('SECOND CHILD'),
              ),
              SpeedDialChild(
                child: Icon(Icons.star),
                backgroundColor: Colors.amber,
                labelWidget: _labelWidget(_postData.isEmpty
                    ? ''
                    : '${_postData['data']['post']['stat']['bookmark_num']}'),
                onTap: () => print('THIRD CHILD'),
              ),
              SpeedDialChild(
                child: Icon(Icons.notifications),
                backgroundColor: Colors.green,
                labelWidget: _labelWidget('举报'),
                onTap: () => print('THIRD CHILD'),
              ),
            ],
          ),
          body: EasyRefresh.custom(
            controller: _controller,
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
            onRefresh: _onRefresh,
            slivers: _postData.isEmpty
                ? [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          height: screenHeight - 56,
                          child: CommonWidget.loading(),
                        );
                      }, childCount: 1),
                    )
                  ]
                : <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Map currentPost = _postData['data']['post'];
                          List<Map> postContent = [];
                          bool isFollowing =
                              currentPost['user']['is_following'];

                          String structuredContent =
                              currentPost['post']['structured_content'];
                          String content = currentPost['post']['content'];

                          if (structuredContent == 'null' ||
                              structuredContent == '') {
                            try {
                              postContent.add(jsonDecode(content));
                            } catch (err) {
                              FLog.error(
                                className: "ForumPostPage",
                                methodName: "_sendCode",
                                text: "$err",
                              );
                              if (_isHtmlTag(content)) {
                                _isHtmlPostContent = true;
                              }
                            }
                          } else {
                            jsonDecode(structuredContent)?.forEach((val) {
                              postContent.add(val as Map);
                            });
                          }

                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                UserProfileLabel(
                                  onAvatarTap: (String heroTag) {
                                    Navigate.navigate(
                                      context,
                                      'userprofile',
                                      arg: {
                                        'heroTag': heroTag,
                                        'uid': currentPost['user']['uid'],
                                      },
                                    );
                                  },
                                  avatarUrl: currentPost['user']['avatar_url'],
                                  nickName: currentPost['user']['nickname'],
                                  level: currentPost['user']['level_exp']
                                      ['level'],
                                  subTitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      NoScaledText(
                                        TinyUtils.humanTime(currentPost['post']
                                                ['created_at'] *
                                            1000),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[300]),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: screenWidth / 4),
                                        child: NoScaledText(
                                          currentPost['user']['certification']
                                              ['label'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[300]),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      CustomIcons.role(currentPost['user']
                                          ['certification']['type']),
                                    ],
                                  ),
                                  extend: () {
                                    return CommonWidget.button(
                                      width: 60,
                                      color: isFollowing
                                          ? Colors.grey[300]
                                          : Colors.blue[200],
                                      content: isFollowing ? '已关注' : '关注',
                                      onPressed: () {
                                        if (_globalModel.isLogin) {
                                          TinyUtils.followUserOperate(
                                              isFollowing,
                                              currentPost['user']['uid'],
                                              (val) {
                                            _controller.callRefresh();
                                          });
                                        } else {
                                          Navigate.navigate(context, 'login');
                                        }
                                      },
                                    );
                                  },
                                ),
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 15, bottom: 25),
                                  child: Wrap(
                                    children: <Widget>[
                                      NoScaledText(
                                        currentPost['post']['subject'],
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 5),
                                  width: screenWidth,
                                  child: _isHtmlPostContent
                                      ? SelfRichTextHtml(content: content)
                                      : SelfRichText(
                                          content: postContent,
                                          emojis: _globalModel
                                              .emojis['list_in_all'],
                                          imagesList: currentPost['post']
                                              ['images'],
                                        ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  child: NoScaledText(
                                    '浏览数: ${currentPost['stat']['view_num']}',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: Wrap(
                                    spacing: 8,
                                    children: currentPost['topics'].map<Widget>(
                                      (ele) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigate.navigate(
                                                context, 'topicinfo',
                                                arg: {'forumId': ele['id']});
                                          },
                                          child: Chip(
                                            backgroundColor: Colors.blue[200],
                                            label: NoScaledText(
                                              ele['name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                                if (_commentList.length == 0)
                                  Container(
                                    height: 70,
                                    child: Center(
                                      child: NoScaledText(
                                        '上滑加载评论',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Map ele = _commentList[index];

                        return CommentBlock(
                          isUpvoted: ele['self_operation']['attitude'] == 1,
                          partOfSubComments: ele['sub_replies'],
                          reply: ele['reply'],
                          replyTargetUser: ele['r_user'],
                          user: ele['user'],
                          likedNum: ele['stat']['like_num'],
                          isLz: ele['is_lz'],
                          onTapUpvote: (isUpvoted) {},
                          onPressedFollow: () {},
                          emojis: _globalModel.emojis['list_in_all'],
                          subCommentsCount: ele['sub_reply_count'],
                        );
                      }, childCount: _commentList.length),
                    ),
                  ],
          ),
        );
      },
    );
  }
}

Handler forumPostPageHandler = Handler(
  pageBuilder: (BuildContext context, arg) {
    return ForumPostPage(
      postId: arg['postId'],
    );
  },
);
