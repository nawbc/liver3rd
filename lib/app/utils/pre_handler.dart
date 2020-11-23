import 'package:flutter/material.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/store/redemption.dart';
import 'package:liver3rd/app/store/settings.dart';
import 'package:liver3rd/app/store/tim.dart';
import 'package:liver3rd/app/store/wallpapers.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:provider/provider.dart';
import 'const_settings.dart';

class NotificationCodeUpdate {
  Future<void> handleCodeHasUpdated(DateTime nowTime, Function callback) async {
    var lastUpdateCode = await Share.getString(REDEMPTION_UPDATE_TIME);
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

Map initHomePageRecPostsQuery(id) {
  return {
    "sink_offset": -1,
    "sink_page_size": 3,
    "is_sink_finish": false,
    "sink_origin_offset": 0,
    "table_offset": 0,
    "table_page_size": 2,
    "is_table_finish": false,
    "game_id": id,
  };
}

class PreHandler {
  // bool _redemptionCodeLocker = true;
  // bool _timLocker = true;

  NotificationCodeUpdate _ncp = NotificationCodeUpdate();

  Future<void> preLoadSettings(BuildContext context) async {
    await Provider.of<Settings>(context, listen: false).initSettings();
  }

  /// [handle] 如果兑换码更新执行回调
  Future<void> preLoadRedemptionCode(BuildContext context,
      {Function onRedemptionsUpdate}) async {
    Redemption redemption = Provider.of<Redemption>(context, listen: false);
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

  Future<void> preLoadGlobalInfo(BuildContext context) async {
    GlobalModel _globalModel = Provider.of<GlobalModel>(context, listen: false);
    await _globalModel.getUserFullInfo();
    if (_globalModel.userInfo.isNotEmpty &&
        _globalModel.userInfo['uid'] != null &&
        _globalModel.userInfo['stoken'] != null &&
        _globalModel.userInfo['data'] != null) {
      _globalModel.setLogin(true);
      // await
    }

    await _globalModel.getGameList(_globalModel.userInfo['uid']);
    await _globalModel.getEmoticonSet();
    Map firstGame =
        _globalModel.gameList.isEmpty ? null : _globalModel.gameList[0];
    if (firstGame != null) {
      await _globalModel.getFirstScreenData(firstGame['id']);
    }
  }

  Future<void> preLoadWallpapers(BuildContext context) async {
    Wallpapers wallpapers = Provider.of<Wallpapers>(context, listen: false);
    if (wallpapers.bhWallpapers.isEmpty) {
      await wallpapers.fetchBhWallpapers();
    }
  }

  Future<void> preLoginTim(BuildContext context) async {
    try {
      String uid = await Share.getString(UID);
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
    } catch (err) {
      FLog.error(text: err, className: 'PreHandler', methodName: 'preLoginTim');
    }
  }
}
