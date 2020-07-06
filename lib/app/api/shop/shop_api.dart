import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/shop/src_links.dart';
import 'package:liver3rd/app/api/utils.dart';

class ShopApi {
  ReqUtils _reqUtils = ReqUtils();
  Future<Map> fetchPresents({int page}) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer:
          'https://webstatic.mihoyo.com/app/community-shop/index.html?bbs_presentation_style=no_header',
      origin: 'https://webstatic.mihoyo.com',
    );
    Response res = await _reqUtils.get(presentsUrl(page: page),
        options: Options(headers: headers));
    return res.data;
  }

  Future<Map> fetchPresentDetail(
      {int appId, String goodsId, String pointSn}) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer:
          'https://webstatic.mihoyo.com/app/community-shop/index.html?bbs_presentation_style=no_header',
      origin: 'https://webstatic.mihoyo.com',
    );
    Response res = await _reqUtils.get(
        presentsDetailUrl(appId: appId, goodsId: goodsId, pointSn: pointSn),
        options: Options(headers: headers));
    return res.data;
  }
}
