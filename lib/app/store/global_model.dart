import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/forum/new_forum.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalModel with ChangeNotifier {
  NewForum _newForum = NewForum();
  UserApi _userApi = UserApi();

  List _gameList = [];
  List get gameList => _gameList;

  List _gameOrder = [];
  List get getGameOrder => _gameOrder;

  Future<void> getGameList(uid, [bool update]) async {
    Map data = await _newForum.fetchGameList();
    Map orderData = await _newForum.fetchGameListOrder(uid);
    List list = data['data']['list'];

    List tmpOrderList = orderData['data']['businesses'];
    _gameOrder = tmpOrderList;
    Map gameMap = list.asMap().map((index, val) {
      return MapEntry('${val['id']}', val);
    });

    _gameList = _gameOrder.map((num) {
      return gameMap[num];
    }).toList();

    if (update != null && update) {
      notifyListeners();
    }
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void setLogin(bool isLogin) {
    _isLogin = isLogin;
  }

  Map _userInfo = {};
  Map get userInfo => _userInfo;

  Future<void> getUserFullInfo({bool isNotify = true}) async {
    String uid = await Share.getString(UID);
    String stoken = await Share.getString(STOKEN);
    Map _data = {"uid": uid, "stoken": stoken};
    Map remoteData = await _userApi.fetchUserAllInfo(uid);
    _data.addAll(remoteData);
    this._userInfo = _data;
  }

  Future<void> logout({Function onSuccess, Function onError}) async {
    _userInfo = {};
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

  Map _emojis = {};
  Map get emojis => _emojis;

  _handleEmoticonSet(List data) {
    Map tmp = {};
    for (var i = 0; i < data.length; i++) {
      List innerList = data[i]['list'];
      for (var j = 0; j < innerList.length; j++) {
        String name = innerList[j]['name'];
        String icon = innerList[j]['icon'];
        tmp[name] = icon;
      }
    }
    return tmp;
  }

  Future<void> getEmoticonSet() async {
    Map data = await _newForum.fetchEmoticonSet();
    if (data['data'] != null) {
      _emojis = {
        "list_in_all": _handleEmoticonSet(data['data']['list']),
        "list": data['data']['list'],
        "recent": data['data']['recently_emoticon']
      };
    }
  }

  Map _firstScreenHomeData = {};
  Map get firstScreenHomeData => _firstScreenHomeData;

  Map _firstScreenPosts = {};
  Map get firstScreenPosts => _firstScreenPosts;

  Future<void> getFirstScreenData(int gids) async {
    _firstScreenPosts = await _newForum.fetchNewPostApi(gids);
    _firstScreenHomeData = await _newForum.fetchNewHomeApi(gids);
  }
}
