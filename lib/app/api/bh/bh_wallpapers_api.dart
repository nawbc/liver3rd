import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/bh/src_links.dart';
import 'package:liver3rd/app/api/utils.dart';

class BhWallpapersApi {
  Future<Map> fetchBhWallpapers() async {
    Response res = await Dio()
        .get(contentListUrl(177),
            options: Options(headers: ReqUtils.siteHeaders))
        .catchError((e) {
      print("Error[WallpaperApi]: $e");
    });
    return res.data;
  }
}
