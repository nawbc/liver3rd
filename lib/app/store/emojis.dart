// import 'package:flutter/material.dart';
// import 'package:liver3rd/app/api/forum/forum_api.dart';

// class Emojis with ChangeNotifier {
//   Map _emojis = {};
//   Map get emojis => _emojis;
//   ForumApi _forumApi = ForumApi();

//   _handleEmoticonSet(List data) {
//     Map tmp = {};
//     for (var i = 0; i < data.length; i++) {
//       List innerList = data[i]['list'];
//       for (var j = 0; j < innerList.length; j++) {
//         String name = innerList[j]['name'];
//         String icon = innerList[j]['icon'];
//         tmp[name] = icon;
//       }
//     }
//     return tmp;
//   }

//   Future<void> fetchEmoticonSet() async {
//     Map data = await _forumApi.fetchEmoticonSet();
//     if (data['data'] != null) {
//       _emojis = {
//         "list_in_all": _handleEmoticonSet(data['data']['list']),
//         "list": data['data']['list'],
//         "recent": data['data']['recently_emoticon']
//       };
//     }
//     notifyListeners();
//   }
// }
