import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/utils.dart';
import 'package:liver3rd/app/api/ys/src_links.dart';

class YsComicsApi {
  ReqUtils _reqUtils = ReqUtils();

  Future<Map> fetchComicsListYS() async {
    var headers = await _reqUtils.setDeviceHeader();
    Response res = await Dio().get(
      ysComicsListUrl,
      options: Options(
        headers: headers,
      ),
    );
    return res.data;
  }
}
