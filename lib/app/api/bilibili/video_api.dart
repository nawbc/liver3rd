import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/bilibili/src_links.dart';

class VideoApi {
  /// [useNumType] av bv
  Future<Map> fetchVideo(String target, {String useNumType = 'target'}) async {
    String bvid;
    int cid;
    int aid;

    if (useNumType == 'av') {
      aid = int.parse(RegExp(r'\d+').stringMatch(target));
      Response cidRes = await Dio().get(videoCidByAidUrl(aid));
      bvid = cidRes.data['data']['bvid'];
      cid = cidRes.data['data']['cid'];
      Response res = await Dio().get(realVideoUrl(cid, bvid));
      return {'data': res.data, 'aid': aid};
    } else {
      if (useNumType == 'bv') {
        bvid = target;
      } else {
        Uri parser = Uri.parse(target);
        Map query = parser.queryParameters;
        if (query['bvid'] == null) {
          bvid = parser.pathSegments[parser.pathSegments.length - 1];
        } else {
          bvid = query['bvid'];
        }
      }
      Response cidRes = await Dio().get(videoCidByBvidUrl(bvid));
      cid = cidRes.data['data'][0]['cid'];
      Response aidRes = await Dio().get(videoAidUrl(bvid, cid));

      Response res = await Dio().get(realVideoUrl(cid, bvid));
      return {'data': res.data, 'aid': aidRes.data['data']['aid']};
    }
  }
}
