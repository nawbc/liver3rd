import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/store/emojis.dart';
import 'package:liver3rd/app/store/games.dart';

import 'package:liver3rd/app/store/posts.dart';
import 'package:liver3rd/app/store/redemption.dart';
import 'package:liver3rd/app/store/settings.dart';
import 'package:liver3rd/app/store/tim.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/store/wallpapers.dart';

import 'package:liver3rd/app/utils/share.dart';
import 'package:provider/provider.dart';
// import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'const_settings.dart';

class NotificationCodeUpdate {
  Future<void> handleCodeHasUpdated(DateTime nowTime, Function callback) async {
    var lastUpdateCode = await Share.shareString(REDEMPTION_UPDATE_TIME);
    if (lastUpdateCode != null) {
      DateTime lastUpdateTime = DateTime.parse(lastUpdateCode);
      if (lastUpdateTime.difference(nowTime).inMilliseconds < 0) {
        callback();
      }
    } else {
      callback();
    }
  }
}

class PreHandler {
  bool _redemptionCodeLocker = true;
  bool _userLocker = true;
  bool _postsLocker = true;
  bool _emoticonSetLocker = true;
  bool _timLocker = true;

  NotificationCodeUpdate _ncp = NotificationCodeUpdate();

  Future<void> preLoadSettings(BuildContext context) async {
    await Provider.of<Settings>(context, listen: false).initSettings();
  }

  /// [handle] 如果兑换码更新执行回调
  Future<void> preLoadRedemptionCode(BuildContext context,
      {Function onRedemptionsUpdate}) async {
    Redemption redemption = Provider.of<Redemption>(context, listen: false);
    if (_redemptionCodeLocker) {
      _redemptionCodeLocker = false;
      await redemption.fetchRedemptionCode();
      var list = redemption.codeList;
      if (list.length > 0) {
        String createTime = list[list.length - 1]['createdAt'];
        // 通知兑换码更新
        _ncp.handleCodeHasUpdated(DateTime.parse(createTime), () async {
          onRedemptionsUpdate(list[list.length - 1]['description']);
          await Share.setString(REDEMPTION_UPDATE_TIME, createTime);
        });
      }
    }
  }

  Future<void> preLoadMyInfo(BuildContext context) async {
    String uid = await Share.shareString(UID);
    String stoken = await Share.shareString(STOKEN);

    if (uid != null && stoken != null) {
      if (_userLocker) {
        _userLocker = false;
        User user = Provider.of<User>(context, listen: false);
        await user.getMyFullInfo();
        if (user.info.isNotEmpty && user.info['data'] != null) {
          user.setLogin(true);
        }
      }
    }
  }

  Future<void> preLoadWallpapers(BuildContext context) async {
    Wallpapers wallpapers = Provider.of<Wallpapers>(context, listen: false);
    if (wallpapers.bhWallpapers.isEmpty) {
      await wallpapers.fetchBhWallpapers();
    }
  }

  Future<void> preLoadGameList(BuildContext context) async {
    Games games = Provider.of<Games>(context, listen: false);
    if (games.gameList.isEmpty) {
      await games.fetchGameList();
    }
  }

  Future<void> preLoadNotifications(BuildContext context) async {
    // Notifications notification =
    //     Provider.of<Notifications>(context, listen: false);
    // if (notification.newest.isEmpty && _notifcationLocker) {
    //   // await notification.fetchAllNotifcations();
    //   _notifcationLocker = false;
    // }
  }

  Future<void> preLoadEmoticons(BuildContext context) async {
    if (_emoticonSetLocker) {
      Emojis emoticons = Provider.of<Emojis>(context, listen: false);
      await emoticons.fetchEmoticonSet();
      _emoticonSetLocker = false;
    }
  }

  Future<void> preLoginTim(BuildContext context) async {
    try {
      String uid = await Share.shareString(UID);
      if (_timLocker) {
        _timLocker = false;
        Tim tim = Provider.of<Tim>(context, listen: false);
        await tim.fetchSig();
        if (tim.sigInfo.isNotEmpty &&
            tim.sigInfo['data'] != null &&
            uid != null) {
          // await TencentImPlugin.initStorage(identifier: uid);
          // await TencentImPlugin.login(
          //   identifier: uid,
          //   userSig: tim.sigInfo['data']['sig'],
          // );
        }
      }
    } catch (err) {
      FLog.error(text: err, className: 'PreHandler', methodName: 'preLoginTim');
    }
  }

  //预加载首页数据
  Future<void> preLoadHomePosts(BuildContext context) async {
    Posts posts = Provider.of<Posts>(context, listen: false);
    if ((posts.appBhHomeData.isEmpty ||
            posts.bhPosts.isEmpty ||
            posts.ysPosts.isEmpty ||
            posts.appYsHomeData.isEmpty) &&
        _postsLocker) {
      _postsLocker = false;
      await posts.fetchPosts(initHomePageRecPostsQuery(1), 1);
      await posts.fetchAppHome(1);
      await posts.fetchPosts(initHomePageRecPostsQuery(2), 2);
      await posts.fetchAppHome(2);
    }
  }
}
