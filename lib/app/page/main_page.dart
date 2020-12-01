import 'package:liver3rd/app/page/forum/more/more_page.dart';
import 'package:liver3rd/app/page/forum/post/post.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/widget/custom_modal_bottom_sheet.dart';
import 'package:liver3rd/app/page/forum/user/my_info_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/widget/bottom_bar.dart';
import 'package:liver3rd/app/widget/double_back.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/utils/const_settings.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  TabController _tabController;
  bool _screenUtilLocker;
  String _heroTag;

  GlobalModel _globalModel;
  int _barIndex = 0;

  @override
  void initState() {
    super.initState();
    _screenUtilLocker = true;
    _heroTag = 'redemptions';
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);

    bool isInited = await Share.getBool(IS_INIT_APP);
    print(isInited);

    if (isInited == null || !isInited) {
      await Future.delayed(Duration(seconds: 4), () async {
        Navigate.navigate(context, 'inapppurchase');
      });
      await Share.setBool(IS_INIT_APP, true);
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
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            heroTag: _heroTag,
            onPressed: () async {
              Navigate.navigate(context, 'redemptions');
            },
            child: CustomIcons.present,
            backgroundColor: Colors.blue[200],
          );
        },
      ),
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
        onHomeTap: () {
          if (mounted) {
            setState(() {
              _barIndex = 0;
            });
          }
        },
        onSettingTap: () {
          Navigate.navigate(context, 'setting');
        },
        onForumTap: () {
          if (mounted) {
            setState(() {
              _barIndex = 1;
            });
          }
        },
      ),
      body: DoubleClickBackWrapper(
        child: [
          PostPage(),
          MorePage(),
        ].elementAt(_barIndex),
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
