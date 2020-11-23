import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:liver3rd/app/api/bh/src_links.dart';
import 'package:liver3rd/app/api/utils.dart';

class ValkyriesApi {
  Future<Map> init() async {
    Response res = await Dio()
        .get(contentListUrl(181),
            options: Options(headers: ReqUtils.siteHeaders))
        .catchError((e) {
      FLog.error(text: e, className: 'ValkyriesApi');
    });
    return res.data;
  }
}
