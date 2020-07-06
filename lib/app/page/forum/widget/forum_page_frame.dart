import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liver3rd/app/app.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:liver3rd/app/api/forum/post_api.dart';
import 'package:liver3rd/app/page/forum/widget/post_block.dart';
import 'package:liver3rd/app/store/posts.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liver3rd/app/widget/user_profile_label.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class ForumPageFrame extends StatefulWidget {
  final int typeId;
  final List<Widget> Function(Map) topics;

  const ForumPageFrame({Key key, this.typeId, this.topics}) : super(key: key);

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
  PostApi _postApi = PostApi();
  Posts _posts;
  List _postList = [];
  Map _pageConfig = {};
  Map _postsMid = {};
  Map _homeDataMid = {};
  List<int> upvotedList = [];

  void _switchForBlock(id) {
    switch (id) {
      case 1:
        _postsMid = _posts.bhPosts;
        _homeDataMid = _posts.appBhHomeData;
        break;
      case 2:
        _postsMid = _posts.ysPosts;
        _homeDataMid = _posts.appYsHomeData;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _posts = Provider.of<Posts>(context, listen: false);
    _switchForBlock(widget.typeId);

    if (_postsMid.isNotEmpty) {
      _postList
          .addAll(_postsMid['data'] != null ? _postsMid['data']['list'] : []);
      _pageConfig = _postsMid['data']['page_config'] != null
          ? _postsMid['data']['page_config']
          : initHomePageRecPostsQuery(widget.typeId);
    } else {
      _onRefresh();
    }

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
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _swiperController?.dispose();
    bddButton?.remove();
    upvotedList = [];
  }

  void _fixGestureConfliction(DragEndDetails details) {
    if (details.primaryVelocity > 0) {
      _swiperController.previous();
    } else {
      _swiperController.next();
    }
  }

  Future _onRefresh() async {
    _postList = [];
    _posts.clear(widget.typeId);

    await _posts.fetchPosts(_pageConfig, widget.typeId);
    await _posts.fetchAppHome(widget.typeId);
    if (mounted) {
      List recPosts = _homeDataMid['data']['recommended_posts'];
      setState(() {
        _switchForBlock(widget.typeId);
        _pageConfig = _postsMid['data']['page_config'];
        _postList.addAll(_postsMid['data']['list'] ?? []);
        if (recPosts != null && recPosts.isNotEmpty)
          _postList = TinyUtils.arrayRandomAssgin(_postList, recPosts);
      });
    }
  }

  Future _onLoad() async {
    _posts.clearPosts(widget.typeId);
    if (_loadPostLocker) {
      _loadPostLocker = false;
      await _posts.fetchPosts(_pageConfig, widget.typeId);
      _loadPostLocker = true;
      if (mounted) {
        setState(() {
          _switchForBlock(widget.typeId);
          _pageConfig = _postsMid['data']['page_config'];
          _postList.addAll(_postsMid['data']['list'] ?? []);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(
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
          _onLoad();
        },
        onRefresh: () async {
          _onRefresh();
        },
        slivers: _postList.isEmpty || _homeDataMid.isEmpty
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
                            List carousels = _homeDataMid['data']['carousels'];
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
                          itemCount: _homeDataMid['data']['carousels'].length,
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
                      height: 85,
                      padding: EdgeInsets.only(
                        top: 14,
                        right: 17,
                        left: 17,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.topics(_homeDataMid),
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
                          await _postApi
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
