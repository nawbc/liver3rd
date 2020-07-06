// import 'package:flutter/widgets.dart';
// import 'package:liver3rd/app/api/bh/bh_notifcation_api.dart';
// import 'package:provider/provider.dart';

// class Notifications with ChangeNotifier {
//   BhNotificationApi _bhNotificationApi = BhNotificationApi();
//   Map _bhNews = {};
//   Map get bhNews => _bhNews;
//   set bhNews(val) {
//     _bhNews = val;
//   }

//   Map _bhAnnouncement = {};
//   Map get bhAnnouncement => _bhAnnouncement;
//   set bhAnnouncement(val) {
//     _bhNews = val;
//   }

//   Map _bhActivity = {};
//   Map get bhActivity => _bhActivity;
//   set bhActivity(val) {
//     _bhNews = val;
//   }

//   Map _ysNews = {};
//   Map get ysNews => _ysNews;
//   set ysNews(val) {
//     _bhNews = val;
//   }

//   Map _ysAnnouncement = {};
//   Map get ysAnnouncement => _ysAnnouncement;
//   set ysAnnouncement(val) {
//     _bhNews = val;
//   }

//   Map _ysActivity = {};
//   Map get ysActivity => _ysActivity;

//   Future<void> fetchBhNews(int type, int offset) async {
//     BuildContext context;
//     Provider.of<Notifications>(context).notifyListeners();
//     switch (type) {
//       case 1:
//         _bhAnnouncement = await _bhNotificationApi.fetchNews(1, 1, offset);
//         break;
//       case 2:
//         _bhActivity = await _bhNotificationApi.fetchNews(1, 2, offset);
//         break;
//       case 3:
//         _bhNews = await _bhNotificationApi.fetchNews(1, 3, offset);
//         break;
//     }
//     notifyListeners();
//   }

//   Future<void> fetchYsNews(int type, int offset) async {
//     switch (type) {
//       case 1:
//         _ysAnnouncement = await _bhNotificationApi.fetchNews(2, 1, offset);
//         break;
//       case 2:
//         _ysActivity = await _bhNotificationApi.fetchNews(2, 2, offset);
//         break;
//       case 3:
//         _ysNews = await _bhNotificationApi.fetchNews(2, 3, offset);
//         break;
//     }
//     notifyListeners();
//   }
// }
