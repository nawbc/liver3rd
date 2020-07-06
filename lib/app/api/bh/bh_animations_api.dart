import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:liver3rd/app/api/bh/src_links.dart';
import 'package:liver3rd/app/api/utils.dart';

class BhAnimationsApi {
  Future<Map> fetchAnimationsList() async {
    Response res = await Dio()
        .get(contentListUrl(179),
            options: Options(headers: ReqUtils.siteHeaders))
        .catchError((e) {
      FLog.error(
          text: e,
          className: 'BhAnimationsApi',
          methodName: 'fetchAnimationsList');
    });
    return res.data;
  }
}
