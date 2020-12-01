import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/base_url.dart';
import 'package:liver3rd/app/api/utils.dart';

class NewForum {
  ReqUtils _reqUtils = ReqUtils(baseUrl: baseFormUrl);
  ReqUtils _reqWebApiUtils = ReqUtils(baseUrl: webApiUrl);

  Future<Map> getFetcher(
    url, {
    query,
    ReqUtils fetcher,
    String referer,
  }) async {
    if (fetcher == null) {
      fetcher = _reqUtils;
    }
    var headers = await fetcher.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await fetcher.get(
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

  Future createMmt() {
    return getFetcher(
      '/Api/create_mmt',
      fetcher: _reqWebApiUtils,
      referer: 'https://bbs.mihoyo.com/',
      query: {
        'scene_type': 1,
        'now': DateTime.now().millisecondsSinceEpoch,
        'reason': 'bbs.mihoyo.com'
      },
    );
  }

  Future getCookieAccountInfoBySToken(String stoken, String uid) async {
    return getFetcher(
      '/auth/api/getCookieAccountInfoBySToken',
      query: {'stoken': stoken, 'uid': uid},
    );
  }

  Future getGameRecordCard(String uid) async {
    return getFetcher(
      '/game_record/card/api/getGameRecordCard',
      query: {'uid': uid},
    );
  }
}
