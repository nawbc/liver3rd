import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/store/global_model.dart';

import 'package:liver3rd/app/store/valkyries.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/pre_handler.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<SplashPage> with TickerProviderStateMixin {
  ForumApi _forumApi = ForumApi();
  PreHandler _preHandler = PreHandler();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Animation<Offset> _animationCenter;
  AnimationController _controllerCenter;
  Animation<Offset> _animationBottom;
  AnimationController _controllerBottom;
  Timer _splashTimer;
  Valkyries _valkyries;
  dynamic _splashMode;
  List<Valkyrie> _valks = [];
  Map _forumSplash = {};
  bool _locker = true;
  int _preLoadDuration = 0;
  Timer _countTimer;

  @override
  void initState() {
    super.initState();
    TinyUtils.setNotification(onSelectNotification: (String payload) {
      // if (payload == 'redemptions') Navigate.navigate(context, 'redemptions');
    });
  }

  @override
  dispose() {
    super.dispose();
    _splashTimer?.cancel();
    _forumApi = null;
    _splashTimer = null;
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    var mode = await Share.getString(SPLASH_MODE);
    if (mounted) {
      setState(() {
        _splashMode = mode ?? SPLASH_MODE_1;
      });
    }

    await _useValkSplashMode();
    await _useForumSplashMode();
  }

  Future<void> _useValkSplashMode() async {
    if (_valks.length == 0) {
      _valkyries = Provider.of<Valkyries>(context, listen: false);
      await _valkyries.fetchValkyries();
      _initCenterBarAnimation();
      _initBottomBarAnimation();
      if (mounted && (_splashMode == SPLASH_MODE_1 || _splashMode == null)) {
        setState(() {
          _valks = _valkyries.valks;
        });
      }
    }
  }

  Future<void> _useForumSplashMode() async {
    if (_forumSplash.isEmpty) {
      Map data = await _forumApi.fetchForumSplash();
      if (mounted && _splashMode == SPLASH_MODE_2) {
        setState(() {
          _forumSplash = data;
        });
      }
    }
  }

  _initCenterBarAnimation() {
    _controllerCenter = AnimationController(
        duration: const Duration(milliseconds: 1600), vsync: this);
    _animationCenter =
        Tween<Offset>(begin: Offset(-0.1, 0), end: Offset(0.1, 0))
            .animate(_controllerCenter);
    _controllerCenter.forward();
  }

  _initBottomBarAnimation() {
    _controllerBottom = AnimationController(
        duration: const Duration(milliseconds: 1600), vsync: this);
    _animationBottom =
        Tween<Offset>(begin: Offset(0.4, 0), end: Offset(0.15, 0))
            .animate(_controllerBottom);
    _controllerBottom.forward();
  }

  Future<void> _preLoadDataSource() async {
    try {
      await _preHandler.preLoadGlobalInfo(context);
      // await _preHandler.preLoadEmoticons(context);
      await _preHandler.preLoadWallpapers(context);
      // await _preHandler.preRenderFirstScreen(context);
      await _preHandler.preLoadRedemptionCode(
        context,
        onRedemptionsUpdate: (String updateContent) async {
          if (Provider.of<GlobalModel>(context, listen: false).isLogin) {
            TinyUtils.showNotification(
              id: NOTIFICATION_DEDEMPTION_ID,
              name: 'redemptionsUpdate',
              title: '有新的兑换码',
              subTitle: updateContent,
              payload: 'redemptions',
            );
          }
        },
      );
      await _preHandler.preLoadSettings(context);
      // await _preHandler.preLoginTim(context);
    } catch (e) {}
  }

  _turnToMainPage(BuildContext context, int duration) async {
    // 提前请求
    if (_locker) {
      // 防止重复刷新 不能放在await 后 可能await期间又刷新了
      _locker = false;

      _countTimer = Timer.periodic(Duration(milliseconds: 100), (val) {
        _preLoadDuration += 100;
      });
      // 预加载
      await _preLoadDataSource();

      _countTimer?.cancel();

      // 如果超过设置时间立即跳转
      _splashTimer = Timer(
          Duration(milliseconds: _preLoadDuration > duration ? 0 : duration),
          () async {
        Navigate.navigate(context, "main", replaceRoute: ReplaceRoute.all);
        _splashTimer?.cancel();
      });
    }
  }

  Widget _valkSplashPage() {
    if (_valks.length > 0) {
      List<int> randomVal = TinyUtils.getRandomSet(3, _valks.length);
      return Container(
        height: 100,
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: _valks[randomVal[0]].backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(30.0, 0),
                      child: CachedNetworkImage(
                        imageUrl: _valks[randomVal[0]].coverUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: _valks[randomVal[1]].backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SlideTransition(
                      position: _animationCenter,
                      child: Transform.translate(
                        offset: _animationCenter.value,
                        child: CachedNetworkImage(
                          imageUrl: _valks[randomVal[1]].coverUrl,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: _valks[randomVal[2]].backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SlideTransition(
                      position: _animationBottom,
                      child: Transform.translate(
                        offset: _animationBottom.value,
                        child: CachedNetworkImage(
                          imageUrl: _valks[randomVal[2]].coverUrl,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(height: 100, color: Colors.white);
    }
  }

  Widget _forumSplashPage() {
    if (_forumSplash.isEmpty) {
      return Container(color: Colors.white);
    }

    if (_forumSplash['data']['splash'] == null) {
      return Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
      );
    } else {
      return Stack(
        children: <Widget>[
          Builder(
            builder: (context) {
              return GestureDetector(
                onLongPress: () async {
                  TinyUtils.saveImgToLocal(
                    _forumSplash['data']['splash']['splash_image'],
                    onSuccess: () {
                      BotToast.showText(text: '保存成功');
                    },
                    onError: () {
                      BotToast.showText(text: '保存失败');
                    },
                  );
                },
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Image.network(
                    _forumSplash['data']['splash']['splash_image'],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(6)),
              margin: EdgeInsets.only(bottom: 20, left: 25),
              padding: EdgeInsets.all(2),
              child: NoScaledText(
                '长按保存图片',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget splashPage;

    switch (_splashMode) {
      case SPLASH_MODE_1:
        _turnToMainPage(context, 3000);
        splashPage = _valkSplashPage();
        break;
      case SPLASH_MODE_2:
        _turnToMainPage(context, 3500);
        splashPage = _forumSplashPage();
        break;
      case SPLASH_MODE_3:
        _turnToMainPage(context, 0);
        splashPage = Container(color: Colors.white);
        break;
      default:
        splashPage = Container(color: Colors.white);
        break;
    }
    return Scaffold(backgroundColor: Colors.white, body: splashPage);
  }
}

var splashPageHandler = Handler(
  transactionType: TransactionType.fromLeft,
  pageBuilder: (BuildContext context, arg) {
    return SplashPage();
  },
);
