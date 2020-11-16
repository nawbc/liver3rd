import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/page/forum/widget/forum_comment_modal.dart';
import 'package:liver3rd/app/page/forum/widget/self_rich_text.dart';
import 'package:liver3rd/app/widget/custom_modal_bottom_sheet.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/reply_modal.dart';
import 'package:liver3rd/app/widget/row_icon_button.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class CommentBlock extends StatefulWidget {
  final bool isUpvoted;

  final List partOfSubComments;
  final Map reply;

  final int likedNum;
  final Map user;
  final bool isLz;
  final Function(bool) onTapUpvote;
  final Function onPressedFollow;
  final Map emojis;
  final int subCommentsCount;
  final Map replyTargetUser;

  const CommentBlock({
    Key key,
    @required this.isUpvoted,
    @required this.partOfSubComments,
    @required this.likedNum,
    @required this.isLz = false,
    @required this.onTapUpvote,
    @required this.onPressedFollow,
    @required this.emojis,
    @required this.subCommentsCount,
    @required this.reply,
    this.replyTargetUser,
    this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentBlockState();
  }
}

class _CommentBlockState extends State<CommentBlock>
    with AutomaticKeepAliveClientMixin {
  TapGestureRecognizer _tapHostGestureRecognizer;
  TapGestureRecognizer _tapBeReplyerGestureRecognizer;
  bool _isUpvote;
  int _likedNum;

  @override
  initState() {
    super.initState();
    _isUpvote = widget.isUpvoted ?? false;
    _likedNum = widget.likedNum;
    _tapBeReplyerGestureRecognizer = TapGestureRecognizer();
    _tapHostGestureRecognizer = TapGestureRecognizer();
  }

  @override
  dispose() {
    super.dispose();
    _tapHostGestureRecognizer?.dispose();
    _tapBeReplyerGestureRecognizer?.dispose();
  }

  TextSpan _replyHead(String name,
      {GestureRecognizer onRespondPressed,
      GestureRecognizer onBeRespondedPressed,
      String replyTargetName}) {
    return TextSpan(
      style: TextStyle(height: 1.5),
      children: [
        if (name != null)
          TextSpan(
            text: name,
            style: TextStyle(color: Colors.blue[200]),
            recognizer: onRespondPressed,
          ),
        if (replyTargetName != null) ...[
          TextSpan(text: ' 回复 ', style: TextStyle(color: Colors.grey)),
          TextSpan(
            text: replyTargetName + ': ',
            style: TextStyle(color: Colors.blue[200]),
            recognizer: onBeRespondedPressed,
          ),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: ScreenUtil().setSp(42),
        color: Colors.grey,
      ),
      child: Container(
        child: Column(
          children: [
            UserProfileLabel(
              avatarSize: 40,
              avatarUrl: widget.user['avatar_url'],
              certificationType: 0,
              level: widget.user['level_exp']['level'],
              nickName: widget.user['nickname'],
              padding:
                  EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 10),
              title: Row(children: [
                NoScaledText(widget.user['nickname']),
                if (widget.isLz)
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: NoScaledText(
                      '楼主',
                      style: TextStyle(color: Colors.amber),
                    ),
                  )
              ]),
              subTitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NoScaledText(
                    DateTime.fromMillisecondsSinceEpoch(
                            widget.reply['created_at'])
                        .toString()
                        .substring(5, 16),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 8),
                  NoScaledText(
                    'F${widget.reply['floor_id'] + 1}',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              extend: () {
                return Container(
                  width: 55,
                  height: 30,
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.blue[200],
                    colorBrightness: Brightness.dark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, size: 13),
                        NoScaledText(
                          '关注',
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                    onPressed: widget.onPressedFollow,
                  ),
                );
              },
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 70, right: 30, top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      List<Map> comments = [];
                      String structContent = widget.reply['struct_content'];
                      if (structContent != 'null' && structContent != '') {
                        jsonDecode(widget.reply['struct_content'])
                            ?.forEach((val) {
                          comments.add(val as Map);
                        });
                      } else {
                        comments.add({"insert": widget.reply['content']});
                      }
                      return SelfRichText(
                        content: comments,
                        emojis: widget.emojis,
                        lineSpacing: 1.5,
                        head: widget.replyTargetUser == null
                            ? null
                            : _replyHead(
                                null,
                                replyTargetName:
                                    widget.replyTargetUser['nickname'],
                                onBeRespondedPressed:
                                    _tapBeReplyerGestureRecognizer
                                      ..onTap = () {
                                        print('target');
                                      },
                                onRespondPressed: _tapHostGestureRecognizer
                                  ..onTap = () {
                                    print('target2');
                                  },
                              ),
                        onContentTap: () {
                          showBottomReply(
                            context,
                            hintText: '回复给 ${widget.user['nickname']}',
                            onSend: (content) {},
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  // 图标
                  Row(
                    children: <Widget>[
                      RowIconButton(
                        icon: CustomIcons.comment(color: Colors.grey[400]),
                        text: '回复',
                        onPressed: () {
                          showBottomReply(
                            context,
                            hintText: '回复给 ${widget.user['nickname']}',
                            onSend: (content) {},
                          );
                        },
                      ),
                      RowIconButton(
                        icon: _isUpvote
                            ? CustomIcons.like(color: Colors.red)
                            : CustomIcons.like(),
                        text: '$_likedNum',
                        onPressed: () {
                          setState(() {
                            _isUpvote ? _likedNum-- : _likedNum++;
                            _isUpvote = !_isUpvote;
                          });
                          widget.onTapUpvote(_isUpvote);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // 子级评论
                  if (widget.partOfSubComments != null &&
                      widget.partOfSubComments.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Container(
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.partOfSubComments
                                .asMap()
                                .map(
                                  (i, ele) {
                                    List<Map> subComments = [];
                                    var struct_content =
                                        ele['reply']['struct_content'];
                                    if (struct_content != null &&
                                        struct_content != "null" &&
                                        struct_content != '') {
                                      jsonDecode(struct_content)
                                          ?.forEach((val) {
                                        subComments.add(val as Map);
                                      });
                                    } else {
                                      subComments.add(
                                          {"insert": ele['reply']['content']});
                                    }

                                    return MapEntry(
                                      i,
                                      SelfRichText(
                                        emojis: widget.emojis,
                                        content: subComments,
                                        lineSpacing: 1.5,
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 8),
                                        backgroundColor: Colors.grey[200],
                                        onContentTap: () {
                                          showBottomReply(
                                            context,
                                            hintText:
                                                '回复给 ${ele['user']['nickname']}',
                                            onSend: (content) async {},
                                          );
                                        },
                                        head: _replyHead(
                                          ele['user']['nickname'],
                                          replyTargetName: ele['r_user']
                                              ['nickname'],
                                          onBeRespondedPressed:
                                              _tapBeReplyerGestureRecognizer
                                                ..onTap = () {
                                                  print('target');
                                                },
                                          onRespondPressed:
                                              _tapHostGestureRecognizer
                                                ..onTap = () {
                                                  print('target2');
                                                },
                                        ),
                                      ),
                                    );
                                  },
                                )
                                .values
                                .toList(),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: InkWell(
                                onTap: () {
                                  showCustomModalBottomSheet(
                                    context: context,
                                    child: ForumCommentModal(
                                      postId: widget.reply['post_id'],
                                      floorId: widget.reply['floor_id'],
                                      replyId: widget.reply['reply_id'],
                                    ),
                                  );
                                },
                                child: NoScaledText(
                                  '查看全部${widget.subCommentsCount}评论',
                                  style: TextStyle(color: Colors.blue[200]),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
