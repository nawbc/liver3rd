import 'package:flutter/widgets.dart';

String presentsUrl({@required int page}) {
  return 'https://api-takumi.mihoyo.com/common/homushop/v1/web/goods/list?app_id=1&point_sn=myb&page_size=20&page=$page&game=';
}

String presentsDetailUrl({int appId, String goodsId, String pointSn}) =>
    'https://api-takumi.mihoyo.com/common/homushop/v1/web/goods/detail?app_id=$appId&point_sn=$pointSn&goods_id=$goodsId';
