import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:liver3rd/app/app.dart';
import 'package:flutter/rendering.dart';
import 'package:liver3rd/app/widget/webview_page.dart';
import 'package:provider/provider.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/api/forum/new_forum.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:liver3rd/app/widget/col_icon_button.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';

class ForumPageFrame extends StatefulWidget {
  final int typeId;
  final int index;

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
              bddButton.show(
                context,
                '回到顶部',
                onPressed: () {
                  _scrollController.jumpTo(0);
                },
                duration: 5,
              );
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

  List _createNavPage() {
    if (_homeData.isNotEmpty) {
      List navigator = _homeData['data']['navigator'].map<Widget>((val) {
        return ColIconButton(
          width: (MediaQuery.of(context).size.width - 34) / 5,
          icon: CachedNetworkImage(imageUrl: val['icon']),
          onPressed: () {
            // Navigate.navigate(context, 'inapppurchase');
            webNavigationHandler(context, val['app_path'],
                val: val, isLogin: _globalModel.isLogin);
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

    List navPage = _createNavPage();

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
                SliverStickyHeader.builder(
                  builder: (context, state) => Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: Opacity(
                          opacity: 0.5,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                child: InkWell(
                                  onTap: () {
                                    Navigate.navigate(context, 'searchpage',
                                        arg: {'gids': widget.typeId});
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      NoScaledText(
                                        '点击搜索..',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Map post = _postList[index];
                        bool isUpvoted =
                            post['self_operation']['attitude'] == 1;
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
                ),
              ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
