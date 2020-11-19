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
      queryParameters: query ?? {},
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

  Future<Map> fetchGameList() async {
    return fetcher(gameListUrl);
  }

  Future<Map> fetchTopicFullInfo(int id) async {
    return fetcher(getTopicFullInfoUrl, query: {'id': id});
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

  Future<Map> fetchAppHome(int gid, {int pageSize = 20}) async {
    return fetcher(appHomeUrl(gid: gid, pageSize: pageSize));
  }

  Future<Map> fetchRecPosts(Map config) async {
    return fetcher(homePageRecPostsUrl, query: config);
  }

  /// 板块api 论坛所有功能 返回置顶内容 [forumId]  1 甲板 4 同人
  Future<Map> fetchForumMain({int forumId}) async {
    return fetcher(forumMainUrl(forumId: forumId));
  }

// https://api-takumi.mihoyo.com/post/api/getForumPostList?forum_id=4&is_good=false&is_hot=false&last_id=&page_size=20&sort_type=1
  /// 返回非置顶内容 [forum_id] 1 甲板 4 同人图
  /// [is_good] 精华
  /// [is_hot] 热门
  /// [sort_type] 1 发帖 2 回复
  Future<Map> fetchForumPostList(
      {int forumId,
      int pageSize = 20,
      bool isGood = false,
      bool isHot = false,
      int sortType = 1,
      String lastId = ""}) async {
    return fetcher(forumPostListUrl, query: {
      'forum_id': forumId,
      'is_good': isGood,
      'is_hot': isHot,
      'last_id': lastId,
      'page_size': pageSize,
      'sort_type': sortType,
    });
  }

  // 返回评论
  Future<Map> fetchPostComment(
      {String postId,
      int orderType = 3,
      String lastId = "0",
      int size = 20}) async {
    return fetcher(commentsUrl, query: {
      'post_id': postId,
      'order_type': orderType,
      'size': size,
      'only_master': false,
      'last_id': lastId,
      'is_hot': true,
    });
  }

  // 发布回复 [replyId] 回复者的id
  Future<Map> releaseReply(
      {String postId,
      String replyId,
      String content,
      String structuredCcontent}) {
    return postFetcher(releaseReplyUrl, query: {
      'content': content,
      'structured_content': structuredCcontent,
      'post_id': postId,
      'reply_id': replyId
    });
  }

  Future<Map> deleteReply({
    String postId,
    String replyId,
  }) {
    return postFetcher(releaseReplyUrl,
        query: {'post_id': postId, 'reply_id': replyId});
  }

  Future<Map> fetchPostSubComments(
      {String postId, int floorId, String lastId = "0", int size = 20}) async {
    return fetcher(subCommentsUrl, query: {
      'post_id': postId,
      'floor_id': floorId,
      'size': size,
      'last_id': lastId,
    });
  }

  Future<Map> fetchRootCommentInfo({String postId, String replyId}) async {
    return fetcher(rootCommentInfoUrl, query: {
      'post_id': postId,
      'reply_id': replyId,
    });
  }

  Future<Map> upvotePost({String postId, bool isCancel = false}) async {
    return postFetcher(
      upvotePostUrl,
      query: {
        'post_id': postId,
        'is_cancel': isCancel,
      },
    );
  }

  Future<Map> fetchFullPost(String postId) async {
    return fetcher(getPostFullUrl(postId));
  }

  Future<Map> sharePost(String postId) async {
    return fetcher(sharePostUrl(postId));
  }

  Future<Map> searchPost(
      {int gids = 1, String keyword = '', bool preview = true}) async {
    return fetcher(searchUrl, query: {
      'gids': gids,
      'keyword': keyword,
      'preview': preview,
    });
  }

  // ?last_id=&list_type=UNKNOWN&page_size=20&topic_id=57
  Future<Map> fetchTopicPostList(
      {int topicId,
      String lastId = '',
      int pageSize = 20,
      String listType = 'UNKNOWN'}) async {
    return fetcher(getTopicPostListUrl, query: {
      'last_id': lastId,
      'list_type': listType,
      'page_size': pageSize,
      'topic_id': topicId,
    });
  }

  Future<Map> fetchNewsList(
      {int gids = 1, int lastId = 0, int pageSize = 20, int type = 2}) async {
    return fetcher(getNewsListUrl, query: {
      'gids': gids,
      'page_size': pageSize,
      'last_id': lastId,
      'type': type,
    });
  }
}
