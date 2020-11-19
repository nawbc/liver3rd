import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:liver3rd/app/page/forum/more/more_page.dart';
import 'package:liver3rd/app/page/forum/send_post_page.dart';
import 'package:liver3rd/app/page/forum/widget/forum_page_frame.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/store/posts.dart';

import 'package:liver3rd/app/widget/col_icon_button.dart';
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
import 'package:liver3rd/app/widget/no_scaled_text.dart';

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
  GlobalModel _globalModel;
  GlobalModel _postModel;
  List<Tab> _tabList = [];

  @override
  void initState() {
    super.initState();

    _locker = true;
    _screenUtilLocker = true;
    _heroTag = 'redemptions';
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);
    _postModel = Provider.of<GlobalModel>(context);

    if (_locker) {
      _locker = false;
      _tabList = _postModel.gameList.map((val) {
        return Tab(
          child: NoScaledText(
            val['name'],
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        );
      }).toList();

      _tabController = TabController(
        length: _tabList.length,
        vsync: ScrollableState(),
      );

      // bool isInited = await Share.getBool(IS_INIT_APP);

      // if (isInited == null || !isInited) {
      //   Dialogs.showPureDialog(context, '一切版权归米忽悠所有');
      //   await Share.setBool(IS_INIT_APP, true);
      // }
    }
  }

  @override
  dispose() {
    super.dispose();
    _tabController?.dispose();
  }

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
            Navigate.navigate(context, 'redemptions');
          },
          child: CustomIcons.present,
          backgroundColor: Colors.blue[200],
        );
      }),
      bottomNavigationBar: BottomBar(
        onDrawerTap: () {
          _globalModel.isLogin
              ? showCustomModalBottomSheet(
                  context: context, child: MyInfoModal())
              : Navigate.navigate(context, 'login');
        },
        onSwitchGameTap: () {
          Navigate.navigate(context, 'switchgame');
        },
        onShopTap: () {
          _globalModel.isLogin
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
                tabs: _tabList,
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
            children: _postModel.gameList.map(
              (val) {
                return ForumPageFrame(
                  typeId: val['id'],
                );
              },
            ).toList(),
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
