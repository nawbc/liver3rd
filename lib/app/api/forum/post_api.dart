import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/src_links.dart';

class PostApi {
  ForumApi _forumApi = ForumApi();

  Future<Map> fetchAppHome(int gid, int pageSize) async {
    return _forumApi.fetcher(appHomeUrl(gid: gid, pageSize: pageSize));
  }

  Future<Map> fetchRecPosts(Map config) async {
    return _forumApi.fetcher(homePageRecPostsUrl, query: config);
  }

  /// 板块api 论坛所有功能 返回置顶内容 [forumId]  1 甲板 4 同人
  Future<Map> fetchForumMain({int forumId}) async {
    return _forumApi.fetcher(forumMainUrl(forumId: forumId));
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
    return _forumApi.fetcher(homeForumPostListUrl, query: {
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
    return _forumApi.fetcher(commentsUrl, query: {
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
    return _forumApi.postFetcher(releaseReplyUrl, query: {
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
    return _forumApi.postFetcher(releaseReplyUrl,
        query: {'post_id': postId, 'reply_id': replyId});
  }

  Future<Map> fetchPostSubComments(
      {String postId, int floorId, String lastId = "0", int size = 20}) async {
    return _forumApi.fetcher(subCommentsUrl, query: {
      'post_id': postId,
      'floor_id': floorId,
      'size': size,
      'last_id': lastId,
    });
  }

  Future<Map> fetchRootCommentInfo({String postId, String replyId}) async {
    return _forumApi.fetcher(rootCommentInfoUrl, query: {
      'post_id': postId,
      'reply_id': replyId,
    });
  }

  Future<Map> upvotePost({String postId, bool isCancel = false}) async {
    return _forumApi.postFetcher(
      upvotePostUrl,
      query: {
        'post_id': postId,
        'is_cancel': isCancel,
      },
    );
  }

  Future<Map> fetchFullPost(String postId) async {
    return _forumApi.fetcher(getPostFullUrl(postId));
  }

  Future<Map> sharePost(String postId) async {
    return _forumApi.fetcher(sharePostUrl(postId));
  }

  Future<Map> searchPost(
      {int gids = 1, String keyword = '', bool preview = true}) async {
    return _forumApi.fetcher(searchUrl, query: {
      'gids': gids,
      'keyword': keyword,
      'preview': preview,
    });
  }
}
