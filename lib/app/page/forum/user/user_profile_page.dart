import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:liver3rd/app/api/forum/new_forum.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/page/forum/user/comment_history_fragment.dart';
import 'package:liver3rd/app/page/forum/user/favorite_fragment.dart';
import 'package:liver3rd/app/page/forum/user/post_history_fragment.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

// import 'package:liver3rd/app/store/wallpapers.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;
  final String heroTag;
  const UserProfilePage({Key key, this.uid, this.heroTag}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserProfilePageState();
  }
}

class _UserProfilePageState extends State<UserProfilePage> {
  TabController _tabController;
  ScrollController _scrollController;
  UserApi _userApi = UserApi();
  SwiperController _swiperController = SwiperController();
  TabBar _tmpTabBar;
  // Wallpapers _wallpapers;
  bool _locker;
  Map _userData = {};
  List _cardList = [];
  GlobalModel _globalModel;
  NewForum _newForum = NewForum();
  bool _displayAppBar = false;

  String _defaultbgUrl =
      'https://oss.turingsenseai.com/1606464150551541334.png';

  List<Widget> _userTabbars = ['帖子', '评论', '收藏'].map<Widget>((val) {
    return NoScaledText(
      val,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
      ),
    );
  }).toList();

  @override
  void initState() {
    super.initState();

    _locker = true;
    _tabController =
        TabController(length: _userTabbars.length, vsync: ScrollableState());
    _tmpTabBar = TabBar(
      indicatorPadding: EdgeInsets.all(0),
      indicator: PointTabIndicator(
        position: PointTabIndicatorPosition.bottom,
        color: Colors.blue[200],
        insets: EdgeInsets.only(bottom: 6),
      ),
      controller: _tabController,
      tabs: _userTabbars,
    );
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);
    if (_locker) {
      _locker = false;
      await _refresh();
      _scrollController
        ..addListener(
          () {
            if (_scrollController.offset < 100) {
              if (_displayAppBar) {
                setState(() {
                  _displayAppBar = false;
                });
              }
            } else {
              if (!_displayAppBar) {
                setState(() {
                  _displayAppBar = true;
                });
              }
            }
          },
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  Future<void> _refresh() async {
    Map userData = await _userApi.fetchUserAllInfo(widget.uid);
    Map cardData = await _newForum.getGameRecordCard(widget.uid);

    _cardList = cardData['data'] != null ? cardData['data']['list'] : [];
    if (mounted) {
      setState(() {
        _userData = userData['data'];
        if (_cardList.isEmpty) {
          _cardList.add({'background_image': _defaultbgUrl});
        }
      });
    }
  }

  Future<void> _followOperate(
      BuildContext context, bool isFollowing, Map currentPost) async {
    if (isFollowing) {
      _userApi.unFollowUser(currentPost['uid']).then((val) async {
        await _refresh();
      }).catchError(() {});
    } else {
      _userApi.followUser(currentPost['uid']).then((val) async {
        await _refresh();
      }).catchError(() {});
    }
  }

  Widget _statisticsCard(String up, String down) {
    return Container(
      width: (MediaQuery.of(context).size.width - 80) / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NoScaledText(
            '$up',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          SizedBox(height: 4),
          NoScaledText('$down', style: TextStyle(color: Colors.grey[400]))
        ],
      ),
    );
  }

  String getLabel() {
    String userLabel = _userData['user_info']['certification']['label'];
    return (userLabel == null || userLabel == '') ? NO_LABEL_STRING : userLabel;
  }

  String getIntroduce() {
    return _userData['user_info']['introduce'] == ''
        ? NO_SIGNNATURE_STRING
        : _userData['user_info']['introduce'];
  }

  Widget _imageCardWithText({
    @required double height,
    @required double width,
    @required String imgUrl,
    @required String title,
    @required String content,
  }) {
    return Container(
      width: width,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: CachedNetworkImage(
                width: height,
                fit: BoxFit.contain,
                imageUrl: imgUrl,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.5, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                NoScaledText(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                NoScaledText(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _displayAppBar
          ? AppBar(
              leading: CustomIcons.back(context),
              title: Wrap(
                children: [
                  ClipOval(
                    child: Container(
                      height: 25,
                      width: 25,
                      color: Colors.white,
                      child: CachedNetworkImage(
                        imageUrl: _userData['user_info']['avatar_url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  CommonWidget.titleText(_userData['user_info']['nickname']),
                ],
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
            )
          : null,
      body: _userData.isEmpty || _cardList.isEmpty
          ? CommonWidget.loading()
          : NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                Map followRelation =
                    _userData != null ? _userData['follow_relation'] : null;
                bool isFollowing = followRelation != null
                    ? followRelation['is_following']
                    : false;

                return <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Positioned(
                                top: -10,
                                child: Container(
                                  child: DefaultTextStyle(
                                    style: TextStyle(color: Colors.white),
                                    child: Swiper(
                                      loop: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: _cardList[index]
                                                  ['background_image'],
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 230,
                                            ),
                                            // Center(
                                            //   child: BackdropFilter(
                                            //     filter: ImageFilter.blur(
                                            //         sigmaX: 2.0, sigmaY: 2.0),
                                            //     child: Opacity(
                                            //       opacity: 0.3,
                                            //       child: Container(
                                            //         decoration: BoxDecoration(
                                            //             color:
                                            //                 Colors.grey[300]),
                                            //         height: 200,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            if (_cardList[index]['data'] !=
                                                null) ...[
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  height: 60,
                                                  color: Colors.black38,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: (_cardList[index]
                                                            ['data'] as List)
                                                        ?.map(
                                                      (val) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            NoScaledText(
                                                              val['value'],
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            NoScaledText(
                                                                val['name']),
                                                          ],
                                                        );
                                                      },
                                                    )?.toList(),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 20,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    NoScaledText(
                                                      _cardList[index]
                                                          ['nickname'],
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Column(
                                                      children: [
                                                        NoScaledText(
                                                          _cardList[index]
                                                              ['region_name'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        NoScaledText(
                                                          '${_cardList[index]['level']}级',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]
                                          ],
                                        );
                                      },
                                      controller: _swiperController,
                                      itemCount: _cardList.length,
                                      itemWidth:
                                          MediaQuery.of(context).size.width,
                                      itemHeight: 200,
                                      layout: SwiperLayout.STACK,
                                      autoplay: _cardList.length != 1,
                                      autoplayDelay: 4000,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -40,
                                left: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80)),
                                  ),
                                  child: Hero(
                                    tag: widget.heroTag ?? '',
                                    child: ClipOval(
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.white,
                                        child: CachedNetworkImage(
                                          imageUrl: _userData['user_info']
                                              ['avatar_url'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 320,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: mediaSize.width - 260),
                                    margin: EdgeInsets.only(left: 120),
                                    child: NoScaledText(
                                      _userData['user_info']['nickname'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CommonWidget.button(
                                        width: 60,
                                        height: 30,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: isFollowing
                                            ? Colors.grey[300]
                                            : Colors.blue[200],
                                        onPressed: () {
                                          if (_globalModel.isLogin) {
                                            _followOperate(context, isFollowing,
                                                _userData['user_info']);
                                          } else {
                                            Navigate.navigate(context, 'login');
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: isFollowing
                                              ? [
                                                  NoScaledText(
                                                    '已关注',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ]
                                              : <Widget>[
                                                  Icon(Icons.add, size: 12),
                                                  NoScaledText(
                                                    '关注',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      CommonWidget.button(
                                        width: 45,
                                        height: 30,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        onPressed: () {
                                          BotToast.showText(text: '功能未实现');
                                        },
                                        content: '私信',
                                        textStyle: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  SizedBox(width: 25),
                                  CustomIcons.badge(width: 15),
                                  SizedBox(width: 5),
                                  Text(
                                    getLabel(),
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  SizedBox(width: 25),
                                  InkWell(
                                    onTap: () async {
                                      await Dialogs.showPureDialog(
                                          context, getIntroduce());
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: mediaSize.width - 40),
                                      child: Text(
                                        '签名: ${getIntroduce()}',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Container(
                                height: 65,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _statisticsCard(
                                        '${_userData['user_info']['achieve']['followed_cnt']}',
                                        '粉丝'),
                                    _statisticsCard(
                                        '${_userData['user_info']['achieve']['follow_cnt']}',
                                        '关注'),
                                    _statisticsCard(
                                        '${_userData['user_info']['achieve']['like_num']}',
                                        '获赞'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 25,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 25),
                                      child: Text(
                                        '社区等级',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      // color: Colors.red,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(left: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: _userData['user_info']
                                                  ['level_exps']
                                              ?.map<Widget>(
                                            (val) {
                                              return _imageCardWithText(
                                                content: 'Lv ${val['level']}',
                                                height: 80,
                                                width: 160,
                                                title: _globalModel.gameMap[
                                                            '${val['game_id']}']
                                                        ['name'] ??
                                                    '',
                                                imgUrl: _globalModel.gameMap[
                                                            '${val['game_id']}']
                                                        ['level_image'] ??
                                                    '',
                                              );
                                            },
                                          )?.toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ];
              },
              body: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: _tmpTabBar.preferredSize.height - 10,
                      child: TabBar(
                        controller: _tabController,
                        indicatorPadding: EdgeInsets.all(0),
                        indicator: PointTabIndicator(
                          position: PointTabIndicatorPosition.bottom,
                          color: Colors.blue[200],
                          insets: EdgeInsets.only(bottom: 4),
                        ),
                        tabs: _userTabbars,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        PostHistoryFragment(uid: widget.uid),
                        CommentHistoryFragment(uid: widget.uid),
                        FavoriteFragment(uid: widget.uid),
                      ]),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

Handler userProfilePageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return UserProfilePage(
      uid: arg['uid'],
      heroTag: arg['heroTag'],
    );
  },
);
