import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/base_url.dart';
import 'package:liver3rd/app/api/utils.dart';

class NewForum {
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

  // tab 顺序
  Future fetchGameListOrder(uid) {
    return getFetcher('/user/api/getUserBusinesses', query: {'uid': uid});
  }

  // 表情
  Future fetchEmoticonSet() {
    return getFetcher('/misc/api/emoticon_set');
  }

  // 帖子列表
  Future fetchNewPostApi(int gids, {String lastId}) {
    return getFetcher('/post/api/feeds/posts',
        query: {'gids': gids, 'last_id': lastId});
  }

  Future fetchNewHomeApi(int gids) {
    return getFetcher(
      '/apihub/api/home/new',
      query: {'gids': gids},
    );
  }
}
