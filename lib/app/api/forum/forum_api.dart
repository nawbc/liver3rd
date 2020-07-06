import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/forum/src_links.dart';
import 'package:crypto/crypto.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/api/utils.dart';
import 'package:path/path.dart' as path;

class ForumApi {
  ReqUtils _reqUtils = ReqUtils();

  Future<Map> fetcher(url, {query}) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await _reqUtils.get(
      url,
      options: Options(headers: headers),
      queryParameters: query == null ? {} : query,
    );

    return res.data;
  }

  Future<Map> postFetcher(url, {query}) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await _reqUtils.post(url,
        options: Options(headers: headers), queryParameters: query ?? {});
    return res.data;
  }

  Future<Map> fetchEmoticonSet() async {
    return fetcher(emotionsUrl);
  }

  Future<Map> uploadRecentEmoticon(List<int> ids) async {
    return postFetcher(uploadRecentEmoticonUrl, query: {
      'ids': ids,
    });
  }

  Future<Map> fetchForumSplash() async {
    return fetcher(forumSplashUrl);
  }

  // 获取上传图片前的验证信息
  Future<Map> fetchUploadVertification(String ext) async {
    String md5String =
        md5.convert(utf8.encode(TinyUtils.makeBase64Uid())).toString();
    return fetcher(uploadVertificationUrl, query: {
      'ext': ext.substring(1),
      'md5': md5String,
    });
  }

  Future<Map> uploadImageToOss(List<int> imageData, String name) async {
    String ext = path.Context().extension(name);
    Map info = await fetchUploadVertification(ext);
    Map params = info['data']['params'];
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    FormData data = FormData.from({
      'signature': params['signature'],
      'file': UploadFileInfo.fromBytes(imageData, name),
      'x:extra': params['callback_var']['x:extra'],
      'key': info['data']['file_name'],
      'callback': params['callback'],
      'policy': params['policy'],
      'name': info['data']['file_name'],
      'OSSAccessKeyId': params['accessid'],
      'success_action_status': 200,
    });
    Response res = await _reqUtils.post(
      params['host'],
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    return res.data;
  }

  Future<Map> fetchAllGamesForum() async {
    return fetcher(allGamesForumUrl);
  }

  Future<Map> fetchFollowerPost({String lastId = '', int pageSize = 20}) async {
    return fetcher(followerPostUrl, query: {
      'last_id': lastId,
      'page_size': pageSize,
    });
  }

  Future<Map> fetchRecommendActiveUserList(
      {String lastId = '0', int pageSize = 10}) {
    return fetcher(recommendActiveUserListUrl, query: {
      'last_id': lastId,
      'page_size': pageSize,
    });
  }

  //即时通讯
  Future<Map> fetchTimSig() {
    return fetcher(getTimSigUrl);
  }

  //关注话题
  Future<Map> followTopic(int id) async {
    return postFetcher(followTopicUrl, query: {'entity_id': id});
  }

  Future<Map> unFollowTopic(int id) async {
    return postFetcher(unFollowTopicUrl, query: {'entity_id': id});
  }

  // 设置隐私
  Future<Map> setUserPrivacy({
    String gids,
    bool collect,
    bool post,
    bool watermark,
  }) async {
    return postFetcher(privacySettingUrl, query: {
      "gids": "1",
      "privacy_invisible_collect": collect,
      "privacy_invisible_post": post,
      "privacy_invisible_watermark": watermark
    });
  }

  /// [type]  1帖子 2话题 3用户
  /// [gids] [keyword] [lastId]
  Future<Map> searchResult(int type,
      {int gids, String keyword, int pageSize = 20, String lastId = ""}) async {
    String url;
    switch (type) {
      case 1:
        url = searchPostsUrl;
        break;
      case 2:
        url = searchTopicsUrl;
        break;
      case 3:
        url = searchUsersUrl;
        break;
      default:
    }

    return fetcher(url, query: {
      'gids': gids,
      'keyword': keyword,
      'last_id': lastId,
      'size': pageSize,
    });
  }
}
