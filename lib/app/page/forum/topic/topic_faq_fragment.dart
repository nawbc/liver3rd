import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';

import 'package:liver3rd/app/page/forum/widget/faq_block.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class TopicFaqFragment extends StatefulWidget {
  final double usedHeight;
  // final int type;
  final bool isGood;
  final bool isHot;
  final int sortType;
  final int forumId;

  const TopicFaqFragment({
    Key key,
    this.usedHeight,
    this.forumId,
    this.isGood = false,
    this.isHot = false,
    this.sortType = 2,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TopicFaqFragmentState();
  }
}

class _TopicFaqFragmentState extends State<TopicFaqFragment>
    with AutomaticKeepAliveClientMixin {
  ForumApi _forumApi = ForumApi();
  Map _tmpData = {};
  List _questionList = [];

  bool _loadPostLocker = true;
  bool _postLastLocker = false;

  didChangeDependencies() async {
    super.didChangeDependencies();

    if (_questionList.isEmpty) {
      await _refresh();
    }
  }

  Future<void> _refresh() async {
    _questionList = [];

    Map tmp = await _forumApi.fetchForumPostList(
        forumId: widget.forumId,
        isGood: widget.isGood,
        isHot: widget.isHot,
        sortType: widget.sortType,
        lastId: "");
    List faqs = tmp['data']['list'];
    _tmpData = tmp;

    if (mounted) {
      setState(() {
        if (faqs.isNotEmpty) {
          _questionList.addAll(faqs);
        }
      });
    }
  }

  Future<void> _onLoadPost(BuildContext context) async {
    if (_postLastLocker) {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('没有新的帖子'));
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
            _questionList.addAll(val['data']['list'] ?? []);
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
    _questionList = [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenHeight = MediaQuery.of(context).size.height;
    return EasyRefresh.custom(
      header: BezierCircleHeader(
          backgroundColor: Colors.white, color: Colors.blue[200]),
      footer: BezierBounceFooter(
          backgroundColor: Colors.white, color: Colors.blue[200]),
      onLoad: () async {
        _onLoadPost(context);
      },
      onRefresh: _refresh,
      slivers: _questionList.isEmpty
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
                    Map question = _questionList[index];
                    Map topUp = question['help_sys']['top_up'];
                    Map user = topUp != null ? topUp['user'] : null;
                    Map reply = topUp != null ? topUp['reply'] : null;

                    return topUp != null
                        ? FaqBlock(
                            onTap: () {
                              Navigate.navigate(context, 'post',
                                  arg: {'postId': question['post']['post_id']});
                            },
                            question: question['post']['subject'],
                            answer: reply['content'],
                            name: user['nickname'],
                            answerCount: question['help_sys']['answer_num'],
                            avatarUrl: user['avatar_url'],
                          )
                        : Container();
                  },
                  childCount: _questionList.length,
                ),
              ),
            ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
