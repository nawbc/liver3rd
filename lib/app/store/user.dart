import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  Map _info = {};
  Map get info => _info;
  // set info(data) {
  //   this._info = data;
  // }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  UserApi _userApi = UserApi();

  void setLogin(bool isLogin) {
    _isLogin = isLogin;
  }

  Future<String> sendMobileCaptcha(String number, {Function onSuccess}) async {
    Map data = await _userApi.createMobileCaptcha(number);
    if (data['data']['status'] == 1) {
      if (onSuccess != null) {
        onSuccess();
      }
    }
    return data['data']['msg'];
  }

  Future<void> getMyFullInfo({bool isNotify = true}) async {
    String uid = await Share.shareString(UID);
    Map data = await _userApi.fetchUserAllInfo(uid);
    this._info = data;
    // if (isNotify) notifyListeners();
  }

  Future<void> logout({Function onSuccess, Function onError}) async {
    _info = {};
    _isLogin = false;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove(UID);
      await prefs.remove(STOKEN);
      await prefs.remove(LTOKEN);
      await prefs.remove(WEB_LOGIN_TOKEN);
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    }
  }
}
