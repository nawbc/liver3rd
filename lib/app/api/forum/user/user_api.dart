import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/user/src_links.dart';
import '../../utils.dart';

class UserApi {
  ReqUtils _reqUtils = ReqUtils();
  ForumApi _forumApi = ForumApi();

  Future<Map> createMobileCaptcha(String phoneNumber) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await Dio()
        .get(getMobileCaptchaUrl(phoneNumber),
            options: Options(headers: headers))
        .catchError((err) {
      FLog.error(
        className: "UserApi",
        methodName: "createMobileCaptcha",
        text: "$err",
      );
    });
    return res.data;
  }

  Future<Map> sendCapcha(String phoneNumber, String captcha) async {
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await Dio()
        .get(checkCaptchaUrl(phoneNumber, captcha),
            options: Options(headers: headers))
        .catchError((err) {
      FLog.error(text: err, className: 'UserApi', methodName: 'sendCapcha');
    });
    return res.data;
  }

  Future<Map> fetchAllTokens({String uid, String webLoginToken}) async {
    String reqTokenUrl = getTokenUrl(uid, webLoginToken);
    var headers = await _reqUtils.setDeviceHeader(
      referer: 'https://app.mihoyo.com',
    );
    Response res = await Dio()
        .get(reqTokenUrl, options: Options(headers: headers))
        .catchError(
      (err) {
        FLog.error(
            text: err, className: 'UserApi', methodName: 'fetchAllTokens');
      },
    );
    return res.data;
  }

  Future<Map> fetchUserAllInfo(String uid) async {
    return _forumApi.fetcher(userInfoUrl(uid));
  }

  Future<Map> fetchMyMissions() async {
    var headers = await _reqUtils.setDeviceHeader(
      referer:
          'https://webstatic.mihoyo.com/app/community-shop/index.html?bbs_presentation_style=fullscreen',
      origin: 'https://webstatic.mihoyo.com',
    );
    Response res = await _reqUtils.get(
      missionsUrl,
      options: Options(
        headers: headers,
      ),
    );
    return res.data;
  }

  Future<Map> fetchMyMissionsState() async {
    var headers = await _reqUtils.setDeviceHeader(
      referer:
          'https://webstatic.mihoyo.com/app/community-shop/index.html?bbs_presentation_style=fullscreen',
      origin: 'https://webstatic.mihoyo.com',
    );
    Response res = await _reqUtils.get(
      missionsStateUrl,
      options: Options(
        headers: headers,
      ),
    );
    return res.data;
  }

  Future<Map> signIn() async {
    return _forumApi.postFetcher(signInUrl, query: {'gids': '1'});
  }

  Future<Map> followUser(String id) {
    return _forumApi.postFetcher(followUserUrl, query: {'entity_id': id});
  }

  Future<Map> unFollowUser(String id) {
    return _forumApi.postFetcher(unFollowUserUrl, query: {'entity_id': id});
  }

  Future<Map> fetchUserPostList(
      {String uid, String lastId = "-1", int pageSize = 20}) {
    return _forumApi.fetcher(userPostListUrl, query: {
      'uid': uid,
      'last_id': lastId,
      'page_size': pageSize,
    });
  }

  Future<Map> fetchUserFavoritePostList(
      {String uid, String lastId = "-1", int pageSize = 20}) {
    return _forumApi.fetcher(userFavoritePostListUrl, query: {
      'uid': uid,
      'last_id': lastId,
      'page_size': pageSize,
    });
  }

  Future<Map> fetchUserReplyList(
      {String uid, String lastId = "-1", int pageSize = 20}) {
    return _forumApi.fetcher(userReplyListUrl, query: {
      'uid': uid,
      'last_id': lastId,
      'page_size': pageSize,
    });
  }

  Future<Map> fetchUserAvatars(
      {String uid, String lastId = "-1", int pageSize = 20}) {
    return _forumApi.fetcher(setUserAvatarsUrl);
  }

  Future<Map> editUserInfo(
      {String avatar,
      String avatarUrl,
      int gender,
      String gids,
      String introduce}) {
    return _forumApi.postFetcher(editUserInfoUrl, query: {
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'gender': gender,
      'gids': gids,
      'introduce': introduce
    });
  }
}
