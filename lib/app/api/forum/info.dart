import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/base_url.dart';
import 'package:liver3rd/app/api/utils.dart';

class InfoApi {
  ReqUtils _reqUtils = ReqUtils(baseUrl: baseFormUrl);

  Future<Map> getFetcher(url, {query}) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await _reqUtils.get(
      url,
      options: Options(headers: headers),
      queryParameters: query ?? {},
    );

    return res.data;
  }

  Future fetchGameList() {
    return getFetcher('/apihub/api/getGameList');
  }

  Future fetchEmoticonSet() {
    return getFetcher('/misc/api/emoticon_set');
  }
}
