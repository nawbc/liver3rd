import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:liver3rd/app/page/ads.dart';
import 'package:liver3rd/app/page/forum/more/more_page.dart';
import 'package:liver3rd/app/page/forum/send_post_page.dart';
import 'package:liver3rd/app/page/forum/widget/forum_page_frame.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/col_icon_button.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/custom_modal_bottom_sheet.dart';
import 'package:liver3rd/app/page/forum/user/my_info_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/widget/bottom_bar.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/widget/double_back.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  InterstitialAd _interstitialAd;
  TabController _tabController;
  bool _screenUtilLocker;
  String _heroTag;
  bool _locker;
  User _user;

  @override
  void initState() {
    super.initState();

    _locker = true;
    _screenUtilLocker = true;
    _heroTag = 'redemptions';

    _tabController = TabController(
      length: _mainPageTabList.length,
      vsync: ScrollableState(),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);

    if (_locker) {
      bool isInited = await Share.shareBool(IS_INIT_APP);

      if (isInited == null || !isInited) {
        Dialogs.showPureDialog(context, '一切版权归米忽悠所有');
        await Share.setBool(IS_INIT_APP, true);
      }
      _locker = false;
    }
  }

  @override
  dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  List<Tab> _mainPageTabList = ['崩坏3', '原神', '更多', '发帖'].map((val) {
    return Tab(
      child: Text(
        val,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    // 初始化 ScreenUtil
    if (_screenUtilLocker) {
      ScreenUtil.init(context);
      _screenUtilLocker = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          heroTag: _heroTag,
          onPressed: () async {
            TinyUtils.checkPurchase(context, () {
              _interstitialAd = createInterstitialAd((event) {
                switch (event) {
                  case MobileAdEvent.leftApplication:
                    Navigate.navigate(context, 'redemptions');
                    _interstitialAd?.dispose();
                    break;
                  case MobileAdEvent.loaded:
                    _interstitialAd.show(
                      anchorType: AnchorType.bottom,
                      anchorOffset: 0.0,
                      horizontalCenterOffset: 0.0,
                    );
                    break;
                  case MobileAdEvent.failedToLoad:
                    Navigate.navigate(context, 'redemptions');
                    FLog.error(
                      className: "MobileAdEvent",
                      methodName: "load",
                      text: "fail to load ads",
                    );
                    break;
                  default:
                    break;
                }
              });
              _interstitialAd..load();
              Scaffold.of(context).showSnackBar(
                CommonWidget.snack(TextSnack['loadingAds'],
                    duration: Duration(milliseconds: 2000)),
              );
            });
          },
          child: CustomIcons.present,
          backgroundColor: Colors.blue[200],
        );
      }),
      bottomNavigationBar: BottomBar(
        onDrawerTap: () {
          _user.isLogin
              ? showCustomModalBottomSheet(
                  context: context, child: MyInfoModal())
              : Navigate.navigate(context, 'login');
        },
        onSwitchGameTap: () {
          Navigate.navigate(context, 'switchgame');
        },
        onShopTap: () {
          _user.isLogin
              ? Navigate.navigate(context, 'shop')
              : Navigate.navigate(context, 'login');
        },
        onSettingTap: () {
          Navigate.navigate(context, 'setting');
        },
      ),
      body: DoubleClickBackWrapper(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            child: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              title: TabBar(
                tabs: _mainPageTabList,
                controller: _tabController,
                indicatorPadding: EdgeInsets.all(0),
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 30.0,
                  indicatorColor: Colors.blue[200],
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
            preferredSize: Size.fromHeight(ScreenUtil().setHeight(90)),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ForumPageFrame(
                  typeId: 1,
                  topics: (homeData) {
                    return <Widget>[
                      ColIconButton(
                        icon: CustomIcons.ship(),
                        onPressed: () {
                          Navigate.navigate(
                            context,
                            'topic',
                            arg: {'forum_id': 1, 'src_type': 0},
                          );
                        },
                        title: '甲板',
                      ),
                      ColIconButton(
                        icon: CustomIcons.flower(),
                        onPressed: () {
                          Navigate.navigate(
                            context,
                            'topic',
                            arg: {'forum_id': 4, 'src_type': 0},
                          );
                        },
                        title: '同人',
                      ),
                      ColIconButton(
                        icon: CustomIcons.workspace(),
                        onPressed: () {
                          Navigate.navigate(
                            context,
                            'topic',
                            arg: {'forum_id': 41, 'src_type': 0},
                          );
                        },
                        title: '同人文',
                      ),
                      ColIconButton(
                        icon: CustomIcons.badge(),
                        onPressed: () async {
                          Navigate.navigate(
                            context,
                            'topic',
                            arg: {'forum_id': 6, 'src_type': 2},
                          );
                        },
                        title: '官方',
                      ),
                      ColIconButton(
                        icon: CustomIcons.mirror(),
                        onPressed: () {
                          Navigate.navigate(
                            context,
                            'searchpage',
                            arg: {'gids': 1},
                          );
                        },
                        title: '搜索',
                      ),
                    ];
                  }),
              ForumPageFrame(
                typeId: 2,
                topics: (homeData) {
                  return <Widget>[
                    ColIconButton(
                      icon: CustomIcons.anchor(),
                      onPressed: () {
                        Navigate.navigate(
                          context,
                          'topic',
                          arg: {'forum_id': 26, 'src_type': 0},
                        );
                      },
                      title: '酒馆',
                    ),
                    ColIconButton(
                      icon: CustomIcons.picture(),
                      onPressed: () {
                        Navigate.navigate(
                          context,
                          'topic',
                          arg: {'forum_id': 29, 'src_type': 0},
                        );
                      },
                      title: '图片',
                    ),
                    ColIconButton(
                      icon: CustomIcons.badge(),
                      onPressed: () {
                        Navigate.navigate(
                          context,
                          'topic',
                          arg: {'forum_id': 28, 'src_type': 2},
                        );
                      },
                      title: '官方',
                    ),
                    ColIconButton(
                      icon: CustomIcons.mirror(),
                      onPressed: () {
                        Navigate.navigate(
                          context,
                          'searchpage',
                          arg: {'gids': 2},
                        );
                      },
                      title: '搜索',
                    ),
                  ];
                },
              ),
              MorePage(),
              SendPostPage(),
            ],
          ),
        ),
      ),
    );
  }
}

var mainPageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return MainPage();
  },
);
