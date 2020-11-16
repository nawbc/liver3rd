import 'dart:async';
import 'dart:io';

import 'package:data_plugin/bmob/bmob.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liver3rd/app/app.dart';
import 'package:liver3rd/app/utils/complish_missions.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

import 'app/utils/tiny_utils.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void _initBmob() {
  Bmob.initMasterKey(BMOB_HOST, BMOB_APP_ID, BMOB_API_KEY, BMOB_MASTER_KEY);
}

void _handleStatusBar() {
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

void _callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    String time = inputData['registerTime'];

    await complishMissions(onSuccess: () {
      debugPrint("success");
    }, onError: (err) {
      FLog.error(
        methodName: "_callbackDispatcher",
        text: "$err",
      );
    });

    await Workmanager.registerOneOffTask(
      Uuid().v4(),
      WORKER_MISSION_NAME,
      tag: WORKER_MISSION_TAG,
      initialDelay: Duration(
        seconds: TinyUtils.nowToTomorrowDuration(time).inSeconds,
      ),
      inputData: {'registerTime': DateTime.now().toString()},
    );

    return Future.value(true);
  });
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (TinyUtils.isDev) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      // 重定向到runZone中处理
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  Workmanager.initialize(_callbackDispatcher, isInDebugMode: TinyUtils.isDev);

  Future<Null> _reportError(dynamic error, dynamic stackTrace) async {}

  _initBmob();
  _enablePlatformOverrideForDesktop();
  _handleStatusBar();

  runZoned<Future<void>>(() async {
    runApp(LiverApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}
