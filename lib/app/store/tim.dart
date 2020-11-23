import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';

class Tim with ChangeNotifier {
  Map _sigInfo = {};
  Map get sigInfo => _sigInfo;
  ForumApi _forumApi = ForumApi();

  Future<void> fetchSig() async {
    _sigInfo = await _forumApi.fetchTimSig();
    notifyListeners();
  }
}
