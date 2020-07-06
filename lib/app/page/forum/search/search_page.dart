import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/api/forum/post_api.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/app/page/forum/search/search_result_fragment.dart';

class SearchHistoryList extends StatefulWidget {
  final Function(String) onChipTap;
  const SearchHistoryList({Key key, this.onChipTap}) : super(key: key);

  @override
  State createState() => _SearchHistoryListState();
}

class _SearchHistoryListState extends State<SearchHistoryList> {
  List<String> _history = [];

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Share.getStringList(SEARCH_HISTORY).then((val) {
      setState(() {
        _history = val ?? [];
      });
    });
  }

  Iterable<Widget> get actorWidgets sync* {
    for (String actor in _history.reversed) {
      yield Padding(
        padding: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            widget.onChipTap(actor);
          },
          child: Chip(
            backgroundColor: Colors.grey[100],
            deleteIcon: Icon(Icons.delete_outline, color: Colors.blue[100]),
            label: Text(actor, style: TextStyle(color: Colors.grey)),
            onDeleted: () {
              setState(() {
                _history.removeWhere((String entry) {
                  return actor == entry;
                });
                Share.removeFromList(SEARCH_HISTORY, actor);
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Text(
              '历史记录',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            SizedBox(width: 15),
            CommonWidget.button(
                width: 40,
                onPressed: () async {
                  await Share.setStringList(SEARCH_HISTORY, []);
                  setState(() {
                    _history = [];
                  });
                },
                content: '清空',
                height: 25),
          ]),
          SizedBox(height: 10),
          Wrap(
            children: actorWidgets.toList(),
          ),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return SearchHistoryList();
}

class SearchPage extends StatefulWidget {
  final int gids;

  const SearchPage({Key key, this.gids = 1}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchTextController;
  bool _isInputing = false;
  PostApi _postApi = PostApi();
  List _posts = [];
  List _topics = [];
  List _users = [];
  User _user;
  double _lrp = 20;
  bool _isSearchSubmit = false;
  int _resultIndex;

  @override
  initState() {
    super.initState();
    _searchTextController = TextEditingController()
      ..addListener(() {
        String searchContent = _searchTextController.text;
        if (searchContent != '') {
          if (mounted)
            setState(() {
              _isInputing = true;
            });

          _refresh(searchContent);
        } else {
          if (mounted)
            setState(() {
              _isInputing = false;
            });
        }
      });
  }

  Future<void> _refresh(String text) async {
    _postApi.searchPost(gids: widget.gids, keyword: text).then((val) {
      if (mounted) {
        setState(() {
          Map data = val['data'];
          if (data != null && data.isNotEmpty) {
            _posts = data['posts'] ?? [];
            _topics = data['topics'] ?? [];
            _users = data['users'] ?? [];
          }
        });
      }
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
  }

  @override
  dispose() {
    super.dispose();
    _searchTextController?.dispose();
  }

  Future<void> _jumpToResult({int resultIndex}) async {
    String val = _searchTextController.text;
    if (val != '') {
      Share.saveToList(SEARCH_HISTORY, val);
      if (mounted) {
        setState(() {
          if (resultIndex != null) {
            _resultIndex = resultIndex;
          }
          _isSearchSubmit = true;
        });
      }
    }
  }

  SliverList _blockTitle(List list, String title, {Function onMoreTap}) {
    return list.length > 0
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(color: Colors.grey, fontSize: 20)),
                      Text.rich(
                        TextSpan(
                            text: '更多 >>',
                            style: TextStyle(
                                color: Colors.blue[200], fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onMoreTap),
                      )
                    ]),
                padding: EdgeInsets.only(left: _lrp, right: _lrp),
              );
            }, childCount: 1),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container();
            }, childCount: 0),
          );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Center(
                child: CommonWidget.borderTextField(
                  hintText: '搜索用户或帖子(点击键盘)',
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _isSearchSubmit = false;
                      });
                    }
                  },
                  onSubmit: (keyword) async {
                    await _jumpToResult();
                  },
                  textController: _searchTextController,
                  withBorder: true,
                  textSize: 16,
                  height: 43,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: _isSearchSubmit
            ? SearchResultFragment(
                gids: widget.gids,
                keyword: _searchTextController.text,
                initialIndex: _resultIndex,
              )
            : EasyRefresh.custom(
                slivers: _isInputing
                    ? [
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return SizedBox(height: 20);
                          }, childCount: 1),
                        ),
                        _blockTitle(_users, '相关用户', onMoreTap: () async {
                          await _jumpToResult(resultIndex: 2);
                        }),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            Map user = _users[index];
                            bool isFollowing = user['is_following'];
                            return UserProfileLabel(
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.only(
                                  top: 10, left: _lrp, right: _lrp, bottom: 10),
                              onAvatarTap: (String heroTag) {
                                Navigate.navigate(
                                  context,
                                  'userprofile',
                                  arg: {
                                    'heroTag': heroTag,
                                    'uid': user['uid'],
                                  },
                                );
                              },
                              avatarUrl: user['avatar_url'],
                              nickName: user['nickname'],
                              subTitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: screenWidth / 2),
                                    child: Text(
                                      user['introduce'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[300]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                    if (_user.isLogin) {
                                      TinyUtils.followUserOperate(
                                        isFollowing,
                                        user['uid'],
                                        (val) async {
                                          if (mounted) {
                                            await _refresh(
                                                _searchTextController.text);
                                          }
                                        },
                                      );
                                    } else {
                                      Navigate.navigate(context, 'login');
                                    }
                                  },
                                );
                              },
                            );
                          }, childCount: _users.length),
                        ),
                        _blockTitle(_posts, '相关帖子', onMoreTap: () async {
                          await _jumpToResult(resultIndex: 0);
                        }),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            Map post = _posts[index];
                            bool isUpvoted =
                                post['self_operation']['attitude'] == 1;

                            return PostBlock(
                              imgList: post['image_list'],
                              onTapUpvote: (isCancel) async {
                                await _postApi.upvotePost(
                                  postId: post['post']['post_id'],
                                  isCancel: isCancel,
                                );
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
                                certificationType: post['user']['certification']
                                    ['type'],
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
                          }, childCount: _posts.length),
                        ),
                        _blockTitle(_topics, '相关话题', onMoreTap: () async {
                          await _jumpToResult(resultIndex: 1);
                        }),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            Map topic = _topics[index];
                            bool isFollowing = topic['is_focus'];
                            return UserProfileLabel(
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.only(
                                  top: 10, left: _lrp, right: _lrp, bottom: 10),
                              avatarUrl: topic['cover'],
                              nickName: topic['name'],
                              subTitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: screenWidth / 2),
                                    child: Text(
                                      topic['desc'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[300]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                    if (_user.isLogin) {
                                      TinyUtils.followTopicOperate(
                                        isFollowing,
                                        topic['id'],
                                        (val) async {
                                          if (mounted)
                                            await _refresh(
                                                _searchTextController.text);
                                        },
                                      );
                                    } else {
                                      Navigate.navigate(context, 'login');
                                    }
                                  },
                                );
                              },
                            );
                          }, childCount: _topics.length),
                        ),
                      ]
                    : <Widget>[
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return SearchHistoryList(
                              onChipTap: (val) {
                                _searchTextController.text = val;
                              },
                            );
                          }, childCount: 1),
                        ),
                      ],
              ),
      ),
    );
  }
}

Handler searchPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return SearchPage(gids: arg['gids']);
  },
);
