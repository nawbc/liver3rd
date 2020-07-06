import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/bh/bh_Wallpapers_api.dart';

class Wallpapers with ChangeNotifier {
  Map _bhWallpapers = {};
  Map get bhWallpapers => _bhWallpapers;
  Map _ysWallpapersMap = {};
  Map get ysWallpapersMap => _ysWallpapersMap;
  BhWallpapersApi _bhWallpapersApi = BhWallpapersApi();
  // YsWallpapersApi _ysWallpapersApi = YsWallpapersApi();

  Future<void> fetchBhWallpapers() async {
    _bhWallpapers = await _bhWallpapersApi.fetchBhWallpapers();
    notifyListeners();
  }

  // Future<void> fetchYsWallpapersList({bool isNotify = false}) async {
  //   _ysWallpapersMap = await _ysWallpapersApi.fetchWallpapersListYS();
  //   if (isNotify) notifyListeners();
  // }
}
