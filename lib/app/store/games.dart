import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';

class Games with ChangeNotifier {
  Map _gameList = {};
  Map get gameList => _gameList;
  ForumApi _forumApi = ForumApi();

  Map _handleData(Map data) {
    List list = data['data']['list'];
    Map games = {};
    for (var game in list) {
      games[game['id']] = game;
    }
    return games;
  }

  Future<void> fetchGameList() async {
    Map tmp = await _forumApi.fetchGameList();
    this._gameList = _handleData(tmp);
  }
}
