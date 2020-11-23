// import 'package:flutter/material.dart';
// import 'package:liver3rd/app/api/forum/forum_api.dart';

// Map initHomePageRecPostsQuery(id) {
//   return {
//     "sink_offset": -1,
//     "sink_page_size": 3,
//     "is_sink_finish": false,
//     "sink_origin_offset": 0,
//     "table_offset": 0,
//     "table_page_size": 2,
//     "is_table_finish": false,
//     "game_id": id,
//   };
// }

// class PostModel with ChangeNotifier {
//   ForumApi _forumApi = ForumApi();

//   Map _firstScreenHomeData = {};
//   Map get firstScreenHomeData => _firstScreenHomeData;

//   Map _firstScreenPosts = {};
//   Map get firstScreenPosts => _firstScreenPosts;

//   Future<void> fetchFirstScreen(int num, Map config) async {
//     print(num);
//     print("=========================");
//     _firstScreenPosts = await _forumApi.fetchAppHome(num);
//     _firstScreenHomeData = await _forumApi.fetchRecPosts(config);
//   }

//   // Map _appBhHomeData = {};
//   // Map get appBhHomeData => _appBhHomeData;
//   // set appBhHomeData(val) {
//   //   _appBhHomeData = val;
//   // }

//   // Map _appYsHomeData = {};
//   // Map get appYsHomeData => _appYsHomeData;
//   // set appYsHomeData(val) {
//   //   _appYsHomeData = val;
//   // }

//   // Map _bhPosts = {};
//   // Map get bhPosts => _bhPosts;
//   // set bhPosts(val) {
//   //   _bhPosts = val;
//   // }

//   // Map _ysPosts = {};
//   // Map get ysPosts => _ysPosts;
//   // set ysPosts(val) {
//   //   _ysPosts = val;
//   // }

//   // Map _fellowPosts = {};
//   // Map get fellowPosts => _fellowPosts;
//   // set fellowPosts(val) {
//   //   _fellowPosts = val;
//   // }

//   // void clear(id) {
//   //   switch (id) {
//   //     case 1:
//   //       {
//   //         _bhPosts = {};
//   //         _appBhHomeData = {};
//   //       }
//   //       break;
//   //     case 2:
//   //       {
//   //         _ysPosts = {};
//   //         _appYsHomeData = {};
//   //       }
//   //       break;
//   //     default:
//   //       {
//   //         _bhPosts = {};
//   //         _appBhHomeData = {};
//   //         _ysPosts = {};
//   //         _appYsHomeData = {};
//   //       }
//   //   }
//   // }

//   // void clearPosts(id) {
//   //   switch (id) {
//   //     case 1:
//   //       _bhPosts = {};
//   //       break;
//   //     case 2:
//   //       _ysPosts = {};
//   //       break;
//   //   }
//   // }

//   // Future<void> fetchAppHome(int id) async {
//   //   switch (id) {
//   //     case 1:

//   //       break;
//   //     case 2:
//   // _appYsHomeData = await _forumApi.fetchAppHome(2, 20);
//   //   }

//   //   notifyListeners();
//   // }

//   // Future<void> fetchPosts(Map config, int id) async {
//   //   switch (id) {
//   //     case 1:
//   // _bhPosts = await _forumApi.fetchRecPosts(config);
//   //     //   break;
//   //     // case 2:
//   //     //   _ysPosts = await _forumApi.fetchRecPosts(config);
//   //   }

//   //   notifyListeners();
//   // }
// }
