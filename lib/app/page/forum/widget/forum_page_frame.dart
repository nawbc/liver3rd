import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liver3rd/app/api/forum/new_forum.dart';
import 'package:liver3rd/app/app.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/topic/topic_page.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/widget/col_icon_button.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class ForumPageFrame extends StatefulWidget {
  final int typeId;
  final int index;
  // final List<Widget> Function(Map) topics;

  const ForumPageFrame({Key key, this.typeId, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ForumPageFrameState();
  }
}

class _ForumPageFrameState extends State<ForumPageFrame>
    with AutomaticKeepAliveClientMixin {
  SwiperController _swiperController = SwiperController();
  ScrollController _scrollController;

  bool _loadPostLocker = true;
  bool _mutex = true;
  ForumApi _forumApi = ForumApi();
  NewForum _newForum = NewForum();
  List _postList = [];
  Map _homeData = {};
  GlobalModel _globalModel;
  String _lastId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(
        () {
          // 没有超出范围 刷新部分
          if (!_scrollController.position.outOfRange) {
            if (_scrollController.position.userScrollDirection ==
                ScrollDirection.reverse) {
              bddButton.show(context, '回到顶部', onPressed: () {
                _scrollController.jumpTo(0);
              }, duration: 5);
            } else {
              bddButton.remove();
            }
          }
        },
      );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);

    if (_mutex) {
      _mutex = false;
      if (widget.index == 0) {
        if (_globalModel.firstScreenHomeData.isNotEmpty &&
            _globalModel.firstScreenPosts.isNotEmpty) {
          _lastId = _globalModel.firstScreenPosts['data']['last_id'];
          _homeData = _globalModel.firstScreenHomeData;
          _postList.addAll(_globalModel.firstScreenPosts['data']['list']);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _swiperController?.dispose();
    bddButton?.remove();
  }

  void _fixGestureConfliction(DragEndDetails details) {
    if (details.primaryVelocity > 0) {
      _swiperController.previous();
    } else {
      _swiperController.next();
    }
  }

  Future _triggerRefresh() async {
    _postList = [];
    var tmpHome = await _newForum.fetchNewHomeApi(widget.typeId);
    Map tmpPostList =
        await _newForum.fetchNewPostApi(widget.typeId, lastId: _lastId);
    _lastId = tmpPostList['data']['last_id'];
    if (mounted) {
      setState(() {
        _homeData = tmpHome;
        _postList.addAll(tmpPostList['data']['list']);
      });
    }
  }

  Future _onLoad() async {
    // _posts.clearPosts(widget.typeId);
    if (_loadPostLocker) {
      _loadPostLocker = false;
      Map tmpPostList =
          await _newForum.fetchNewPostApi(widget.typeId, lastId: _lastId);
      _lastId = tmpPostList['data']['last_id'];
      _loadPostLocker = true;
      if (mounted) {
        setState(() {
          _postList.addAll(tmpPostList['data']['list']);
        });
      }
    }
  }

  List createNavPage() {
    if (_homeData.isNotEmpty) {
      List navigator = _homeData['data']['navigator'].map<Widget>((val) {
        return ColIconButton(
          width: (MediaQuery.of(context).size.width - 34) / 5,
          icon: CachedNetworkImage(imageUrl: val['icon']),
          onPressed: () {
            if (val['id'] == 78) {
              Navigate.navigate(context, 'bhcomic');
              return;
            }

            Uri uri = Uri.parse(val['app_path']);

            switch (uri.scheme) {
              case 'https':
              case 'http':
                Navigate.navigate(context, 'webview', arg: {
                  'title': val['name'],
                  'url': val['app_path'],
                  'headers': {
                    'cookie':
                        '_MHYUUID=c4ba8758-80d3-4cab-9ca0-47c133b64e79;UM_distinctid=175c62a134a916-077d1dfab35f5d-230346c-144000-175c62a134bb20;account_id=81092022;cookie_token=9krJd6b3IkekPYfJzgugLTMEcN0fEpOEbHoQPFvJ;ltoken=EIpvRHnvTixZV32cHp6FOmnix2zsShuoMF5bdxyL;ltuid=81092022;_gid=GA1.2.1502881436.1605935296; _ga=GA1.1.794644750.1605347449;_ga_SCWM2QBF4E=GS1.1.1606026553.1.1.1606026556.0',
                  }
                });
                break;
              case 'mihoyobbs':
                switch (uri.host) {
                  case 'article':
                    if (uri.pathSegments.isNotEmpty) {
                      Navigate.navigate(context, 'post',
                          arg: {'postId': uri.pathSegments[0]});
                    }
                    break;
                  case 'forum':
                    if (uri.pathSegments.isNotEmpty) {
                      Navigate.navigate(context, 'topic', arg: {
                        'forum_id': uri.pathSegments[0] is String
                            ? int.parse(uri.pathSegments[0])
                            : null,
                      });
                    }
                    break;
                  default:
                }
                break;
              default:
                BotToast.showText(text: '功能未实现');
                break;
            }

            // Navigate.navigate(
            //   context,
            //   'topic',
            //   arg: {'forum_id': 1, 'src_type': 0},
            // );
          },
          title: val['name'],
        );
      }).toList();
      int navPageCount = (navigator.length / 5).ceil();
      List navPage = [];
      for (var i = 0; i < navPageCount; i++) {
        int start = i * 5;
        int end = ((i + 1) * 5) >= navigator.length
            ? navigator.length
            : ((i + 1) * 5);
        navPage.add(navigator.getRange(start, end).toList());
      }
      return navPage.map((list) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: list,
        );
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List navPage = createNavPage();

    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(
        scrollController: _scrollController,
        firstRefresh: widget.index != 0,
        header: BezierCircleHeader(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        footer: BezierBounceFooter(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        onLoad: _onLoad,
        onRefresh: _triggerRefresh,
        slivers: _postList.isEmpty || _homeData.isEmpty
            ? <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: EmptyWidget(
                        subTitle: '布洛妮娅, 请求刷新',
                      ),
                    );
                  }, childCount: 1),
                ),
              ]
            : <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.width / (16 / 8) + 10,
                      child: GestureDetector(
                        onHorizontalDragEnd: _fixGestureConfliction,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            List carousels =
                                _homeData['data']['carousels']['data'];
                            return GestureDetector(
                              onTap: () {
                                String postId = RegExp(r'\d+')
                                    .stringMatch(carousels[index]['app_path']);
                                Navigate.navigate(context, 'post',
                                    arg: {'postId': postId});
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  imageUrl: carousels[index]['cover'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                          controller: _swiperController,
                          itemCount:
                              _homeData['data']['carousels']['data'].length,
                          itemWidth: MediaQuery.of(context).size.width,
                          itemHeight:
                              MediaQuery.of(context).size.width / (16 / 8),
                          layout: SwiperLayout.TINDER,
                          autoplay: true,
                          autoplayDelay: 6000,
                        ),
                      ),
                    );
                  }, childCount: 1),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      height: 98,
                      padding: EdgeInsets.only(
                        right: 17,
                        left: 17,
                      ),
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return navPage[index];
                        },
                        itemCount: navPage.length,
                        pagination: SwiperPagination(
                          margin: EdgeInsets.only(top: 20),
                          builder: DotSwiperPaginationBuilder(
                            color: Colors.black12,
                            activeColor: Colors.blue[200],
                            size: 7.0,
                            activeSize: 10.0,
                          ),
                        ),
                      ),
                    );
                  }, childCount: 1),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Map post = _postList[index];
                      bool isUpvoted = post['self_operation']['attitude'] == 1;
                      return PostBlock(
                        imgList: post['image_list'],
                        onTapUpvote: (isCancel) async {
                          await _forumApi
                              .upvotePost(
                            postId: post['post']['post_id'],
                            isCancel: isCancel,
                          )
                              .catchError((err) {
                            FLog.error(
                                className: 'ForumPageFrame', text: '$err');
                          });
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
                    },
                    addRepaintBoundaries: false,
                    childCount: _postList.length,
                    addAutomaticKeepAlives: true,
                  ),
                ),
              ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
