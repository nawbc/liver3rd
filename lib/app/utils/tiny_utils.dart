import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'const_settings.dart';

class TinyUtils {
  static bool get isDev {
    bool flag = false;
    assert(flag = true);
    return flag;
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static String makeUid() {
    return (DateTime.now().millisecondsSinceEpoch + Random().nextInt(0xff00000))
        .toString();
  }

  static String makeBase64Uid({String other}) {
    return base64Encode(utf8.encode(makeUid() + (other ?? '')));
  }

  static List<int> getRandomSet(int count, int max) {
    List<int> tmp = [];
    for (var i = 0; i < count; i++) {
      int num = Random().nextInt(max);
      if (!tmp.contains(num)) {
        tmp.add(num);
      } else {
        count++;
      }
    }
    return tmp;
  }

  static bool isLegalChinesePN(String str) {
    return RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  static void openUrl(String url, {Function error, Function success}) async {
    if (await canLaunch(url)) {
      await launch(url);
      if (success != null) {
        success();
      }
    } else {
      print('Could not launch $url');
      if (error != null) {
        error();
      }
    }
  }

  static Color randomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
    if (r == 0 || g == 0 || b == 0) return Colors.black;
    if (a == 0) return Colors.white;
    return Color.fromARGB(
      a,
      r != 255 ? r : Random.secure().nextInt(r),
      g != 255 ? g : Random.secure().nextInt(g),
      b != 255 ? b : Random.secure().nextInt(b),
    );
  }

  static List<Color> randomColorList(int count) {
    List<Color> list = [];
    for (var i = 0; i < count; i++) {
      list.add(randomColor());
    }
    return list;
  }

  static Future<bool> checkPermissionAndRequest(PermissionGroup p) async {
    PermissionStatus status =
        await PermissionHandler().checkPermissionStatus(p);
    if (PermissionStatus.granted != status) {
      PermissionHandler().requestPermissions(<PermissionGroup>[p]);
      return false;
    } else {
      return true;
    }
  }

  static saveImgToLocal(String url,
      {Function onError,
      Function onSuccess,
      Function(int, int) onLoading}) async {
    if (await TinyUtils.checkPermissionAndRequest(PermissionGroup.storage)) {
      Response response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes),
              onReceiveProgress: (a, b) {
        // double c = a / b;
        if (onLoading != null) onLoading(a, b);
      });
      if (response.statusCode == 200) {
        var result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data));
        if (result != null) {
          if (onSuccess != null) {
            onSuccess();
          }
        } else {
          onError();
        }
      }
    }
  }

  static Future<FlutterLocalNotificationsPlugin> setNotification(
      {@required Function onSelectNotification}) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher_round');
    var ios = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, ios);
    await flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    return flutterLocalNotificationsPlugin;
  }

  static Future<void> showNotification({
    @required String id,
    @required String name,
    @required String title,
    @required String subTitle,
    @required String payload,
  }) async {
    var android = AndroidNotificationDetails(id, name, 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(0, title, subTitle, platform,
        payload: payload);
  }

  static bool include(String origin, String target) {
    return RegExp("$target").hasMatch(origin);
  }

  static String humanTime(int time, {int from = 5, int end = 16}) {
    return DateTime.fromMillisecondsSinceEpoch(time)
        .toString()
        .substring(from, end);
  }

  //阿里云 https://www.alibabacloud.com/help/zh/doc-detail/44688.htm?spm=a2c63.p38356.b99.791.21c6496c5aeVLk
  // 暂未得出 最长边使用的算法
  static thumbnailUrl(String basicUrl, {String size = '768'}) {
    return basicUrl + '?x-oss-process=image/resize,l_$size/quality,q_80';
  }

  static fixGestureConfliction(
      DragEndDetails details, SwiperController controller) {
    if (details.primaryVelocity > 0) {
      controller.previous();
    } else {
      controller.next();
    }
  }

  static Future<void> followUserOperate(
      bool isFollowed, String uid, Function(Map<dynamic, dynamic>) onSuccess,
      {Function onError}) async {
    if (isFollowed) {
      UserApi().unFollowUser(uid).then(onSuccess).catchError(onError ?? () {});
    } else {
      UserApi().followUser(uid).then(onSuccess).catchError(onError ?? () {});
    }
  }

  static Future<void> followTopicOperate(
      bool isFollowed, int id, Function(Map<dynamic, dynamic>) onSuccess,
      {Function onError}) async {
    if (isFollowed) {
      ForumApi().unFollowTopic(id).then(onSuccess).catchError(onError ?? () {});
    } else {
      ForumApi().followTopic(id).then(onSuccess).catchError(onError ?? () {});
    }
  }

  static Duration nowToTomorrowDuration(String time) {
    DateTime a = DateTime.parse(time);
    DateTime n = DateTime.now();
    setToday(day) {
      DateTime m = DateTime(n.year, n.month, day, a.hour, a.minute, a.second);
      return m.difference(n);
    }

    Duration unknownDuration = setToday(n.day);
    return unknownDuration.inSeconds - 1 > 0
        ? unknownDuration
        : setToday(n.day + 1);
  }

  static int pathId(String path) {
    return int.parse(RegExp(r'\d+').stringMatch(path));
  }

  static String pathStringId(String path) {
    return RegExp(r'\d+').stringMatch(path);
  }

  static Future<Directory> logDir() async {
    Directory externalDir = await getExternalStorageDirectory();
    return new Directory('$externalDir/FLogs');
  }

  static Future<void> createDir(Directory dir,
      {onError, recursive = false}) async {
    try {
      if (await checkPermissionAndRequest(PermissionGroup.storage)) {
        await dir.create(recursive: recursive);
      }
    } catch (err) {
      if (onError != null) onError(err);
    }
  }

  static List arrayRandomAssgin([List a = const [], List b = const []]) {
    List list = a + b;
    list.sort((a, b) => Random().nextDouble() > 0.5 ? -1 : 1);
    return list;
  }

  static Future<void> checkPurchase(
      BuildContext context, Function callback) async {
    if (await Share.shareBool(IS_PURCHASE) == null) {
      Navigate.navigate(context, 'inapppurchase');
    } else {
      callback();
    }
  }

  static dynamic selectGender(int num, {double width = 15}) {
    switch (num) {
      case 0:
        return CustomIcons.unknown(width: width);
      case 1:
        return CustomIcons.male(width: width);
      case 2:
        return CustomIcons.female(width: width);
    }
  }
}
