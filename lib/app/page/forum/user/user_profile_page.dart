import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter/rendering.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/page/forum/user/comment_history_fragment.dart';
import 'package:liver3rd/app/page/forum/user/favorite_fragment.dart';
import 'package:liver3rd/app/page/forum/user/post_history_fragment.dart';

import 'package:liver3rd/app/store/user.dart';

import 'package:liver3rd/app/store/wallpapers.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:liver3rd/custom/extended_nested_scroll_view/src/old_extended_nested_scroll_view.dart';
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
  TabBar _tmpTabBar;
  Wallpapers _wallpapers;
  Map _userData = {};
  int _counter = 0;
  User _user;

  String _defaultBackgroundImageUrl =
      'https://uploadstatic.mihoyo.com/contentweb/20200410/2020041019014847737.png';
  String _backgroundImageUrl = '';
  Map _initUserData = {
    'avatar_url': '',
    'nickname': '',
    'certification': {'label': ''},
    'introduce': '',
    'gender': 1,
    'achieve': {
      'follow_cnt': '',
      'followed_cnt': '',
      'like_num': '',
    },
    'level_exps': [
      {'game_id': 1, 'level': 1},
      {'game_id': 2, 'level': 1}
    ],
    'uid': '81092022',
  };

  List<Widget> _userTabbars = ['帖子', '评论', '收藏'].map<Widget>((val) {
    return Text(
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
    _wallpapers = Provider.of<Wallpapers>(context, listen: false);
    try {
      List wallpaperList = _wallpapers.bhWallpapers['data']['list'];
      _backgroundImageUrl =
          wallpaperList[Random().nextInt(wallpaperList.length)]['ext'][0]
              ['value'][0]['url'];
    } catch (e) {
      _backgroundImageUrl = _defaultBackgroundImageUrl;
    }

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
    _scrollController = ScrollController()
      ..addListener(
        () {
          // 解决异形屏sliverappbar 由于不能改变高度, tabbar  被遮盖问题
          if (_scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse &&
              _counter == 7) {
            setState(() {});
          } else if (_scrollController.position.userScrollDirection ==
                  ScrollDirection.forward &&
              _counter == 7) {
            setState(() {});
          }
          if (_counter <= 7) _counter++;
          if (_counter == 8) _counter = 0;
        },
      );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    if (_userData.isEmpty) {
      await _refresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  Future<void> _refresh() async {
    Map tmp = await _userApi.fetchUserAllInfo(widget.uid);

    if (mounted) {
      setState(() {
        _userData = tmp;
      });
    }
  }

  Widget _imageCardWithText(
      {@required double width,
      @required double height,
      @required String imgUrl,
      @required String title,
      @required String content}) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset(
                imgUrl,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.7, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _statisticsCard(double width, String up, String down) {
    return Container(
      width: (width - 80) / 3,
      child: Column(
        children: <Widget>[
          Text('$up', style: TextStyle(fontSize: 18)),
          SizedBox(height: 4),
          Text('$down', style: TextStyle(color: Colors.grey))
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    double cardImageHeight = mediaSize.width * 174 / 567;
    double cardImageWidth = mediaSize.width / 2;
    double avatarSize = 80;
    double paddingTop = MediaQuery.of(context).padding.top;

    /// 遮盖 SliverPersistentHeader  tabbat pain  时的超出部分
    double maskHeight = 20;

    /// pain 时候 顶部距离 如果padding小于tabbar高度 使用tabbar
    double topPaddingHeight =
        (paddingTop < (avatarSize / 2) ? (avatarSize / 2) : paddingTop) -
            maskHeight;

    bool isLawUser = _userData.isNotEmpty && _userData['data'] != null;
    Map followRelation =
        isLawUser ? _userData['data']['follow_relation'] : null;
    bool isFollowing =
        followRelation == null ? false : followRelation['is_following'];

    Map userInfo = isLawUser ? _userData['data']['user_info'] : _initUserData;
    String userLabel = userInfo['certification']['label'];
    userLabel =
        (userLabel == null || userLabel == '') ? NO_LABEL_STRING : userLabel;
    String introduce = userInfo['introduce'] == ''
        ? NO_SIGNNATURE_STRING
        : userInfo['introduce'];

    Map gameLevels = {};
    (userInfo['level_exps'] as List).forEach((val) {
      if ([1, 2].contains(val['game_id'])) {
        gameLevels[val['game_id']] = val['level'];
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return topPaddingHeight;
        },
        innerScrollPositionKeyBuilder: () {
          String index = 'user_profile_tab';
          index += _tabController.index.toString();
          return Key(index);
        },
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              leading: CustomIcons.back(context),
              expandedHeight: mediaSize.height / 4,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(),
                centerTitle: true,
                background: CachedNetworkImage(
                  imageUrl: _backgroundImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Container(
                  height: 120,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                        left: 20,
                        bottom: -avatarSize / 2,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 5, color: Colors.white),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(avatarSize))),
                          child: Hero(
                            tag: widget.heroTag ?? '',
                            child: ClipOval(
                              child: Container(
                                height: avatarSize,
                                width: avatarSize,
                                color: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl: userInfo['avatar_url'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 120,
                        bottom: 8,
                        child: Container(
                          width: mediaSize.width - 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: mediaSize.width - 240),
                                      child: Text(
                                        userInfo['nickname'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CommonWidget.button(
                                            width: 50,
                                            height: 26,
                                            color: isFollowing
                                                ? Colors.grey[300]
                                                : Colors.blue[200],
                                            onPressed: () {
                                              if (_user.isLogin) {
                                                _followOperate(context,
                                                    isFollowing, userInfo);
                                              } else {
                                                Navigate.navigate(
                                                    context, 'login');
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: isFollowing
                                                  ? [
                                                      Text(
                                                        '已关注',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      )
                                                    ]
                                                  : <Widget>[
                                                      Icon(Icons.add, size: 12),
                                                      Text(
                                                        '关注',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      )
                                                    ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          CommonWidget.button(
                                            width: 40,
                                            height: 26,
                                            onPressed: () {},
                                            content: '私信',
                                            textStyle: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                              Row(
                                children: [
                                  CustomIcons.badge(width: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    userLabel == '' ? '路人甲' : userLabel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -avatarSize / 3,
                        child: InkWell(
                          onTap: () async {
                            await Dialogs.showPureDialog(context, introduce);
                          },
                          child: Container(
                            height: topPaddingHeight,
                            constraints: BoxConstraints(
                                maxWidth: mediaSize.width - avatarSize + 40),
                            padding: EdgeInsets.only(left: avatarSize + 40),
                            child: Text(
                              '签名: $introduce',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                maxHeight: (avatarSize / 2) + 225 + maskHeight,
                minHeight: (avatarSize / 2) + 225 + maskHeight,
                child: Column(children: [
                  SizedBox(height: 5),
                  SizedBox(height: avatarSize / 2),
                  Container(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _statisticsCard(mediaSize.width,
                            '${userInfo['achieve']['followed_cnt']}', '粉丝'),
                        _statisticsCard(mediaSize.width,
                            '${userInfo['achieve']['follow_cnt']}', '关注'),
                        _statisticsCard(mediaSize.width,
                            '${userInfo['achieve']['like_num']}', '获赞'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25,
                          padding: EdgeInsets.only(left: 22),
                          child: Text(
                            '社区等级',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: cardImageHeight,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding:
                                EdgeInsets.only(right: 15, left: 15, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _imageCardWithText(
                                  imgUrl: 'assets/images/bh_level.png',
                                  width: cardImageWidth,
                                  content: 'Lv ${gameLevels[1]}',
                                  title: '崩坏3',
                                  height: cardImageHeight,
                                ),
                                _imageCardWithText(
                                  imgUrl: 'assets/images/ys_level.png',
                                  width: cardImageWidth,
                                  content: 'Lv ${gameLevels[2]}',
                                  title: '原神',
                                  height: cardImageHeight,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: maskHeight)
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: _tmpTabBar.preferredSize.height,
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  PostHistoryFragment(uid: widget.uid),
                  CommentHistoryFragment(uid: widget.uid),
                  FavoriteFragment(uid: widget.uid),
                ]
                    .asMap()
                    .map(
                      (index, child) {
                        return MapEntry(
                          index,
                          NestedScrollViewInnerScrollPositionKeyWidget(
                            Key("user_profile_tab$index"),
                            child,
                          ),
                        );
                      },
                    )
                    .values
                    .toList(),
              ),
            )
          ],
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
