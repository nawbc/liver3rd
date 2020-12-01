//============================================================================================================
/// [type] comment 赞通知  system 系統通知 reply 回复通知
String notificationUrl({String type, int pageSize = 20}) =>
    'https://api-takumi.mihoyo.com/notification/api/getUserNotifications?category=$type&page_size=$pageSize&last_id=0';

//米游社区的画报splash
final String forumSplashUrl =
    'https://api-takumi.mihoyo.com/apihub/api/getSplash';

//============================================================================================================

/// 主页帖子[gid] 1 崩坏3 2 原神
String appHomeUrl({int gid, int pageSize = 20}) =>
    'https://api-takumi.mihoyo.com/apihub/api/appHome?gids=$gid&page=1&page_size=$pageSize';

/// 新增内容list 代表新增的帖子
/// table_offset=3 随上拉滚动刷新 递增3 sink_offset 增2 其他参数不变
/// [game_id] 1 崩坏， 2 原神  3 崩2
/// [sinkOffset] 初始 -1
/// [sink_origin_offset] 初始 0 保持不变 根据返回的page_config里的
/// [table_offset] 初始 0
/// [sink_page_size] 初始3
String homePageRecPostsUrl =
    'https://api-takumi.mihoyo.com/post/api/getHomePageRecPosts';

/// 论坛所有功能 返回置顶内容
/// [forumId]
/// 崩坏 1 甲板 4 同人
/// cookie
String forumMainUrl({int forumId}) =>
    'https://api-takumi.mihoyo.com/apihub/api/forumMain?forum_id=$forumId';

// 获取fourm发布的通知 如测试
String gameConfigUrl(int gid) =>
    'https://api-takumi.mihoyo.com/reception/api/homePageGetGameConfigs?gid=$gid';

// 游戏列表
String gameListUrl = 'https://api-takumi.mihoyo.com/apihub/api/getGameList';

// tab 页排序
// String gameListOrder(String uid) =>
//     'https://api-takumi.mihoyo.com/user/api/getUserBusinesses?uid=$uid';

/// 论A
/// [forum_id] 1 甲板 4 同人 6 官方 21 问答 5 反馈
/// forum_id=4&is_good=false&is_hot=false&last_id=&page_size=20&sort_type=1
final String forumPostListUrl =
    'https://api-takumi.mihoyo.com/post/api/getForumPostList';

// 帖子
String getPostFullUrl(String postId) =>
    'https://api-takumi.mihoyo.com/post/api/getPostFull?post_id=$postId';

/// 分享帖子
String sharePostUrl(String postId) =>
    'https://api-takumi.mihoyo.com/apihub/api/getShareConf?entity_type=1&entity_id=$postId';

//============================================================================================================
// 搜索
final String searchUrl = "https://api-takumi.mihoyo.com/apihub/api/search";
final String searchTopicsUrl =
    "https://api-takumi.mihoyo.com/topic/api/searchTopic";
final String searchPostsUrl =
    "https://api-takumi.mihoyo.com/post/api/searchPosts";
final String searchUsersUrl =
    "https://api-takumi.mihoyo.com/user/api/searchUser";
//============================================================================================================

/// 评论
final String commentsUrl =
    'https://api-takumi.mihoyo.com/post/api/getPostReplies';
// 'https://api-takumi.mihoyo.com/post/api/hotReplyList?post_id=$postId&limit=20&last_id=';

final String subCommentsUrl =
    'https://api-takumi.mihoyo.com/post/api/getSubReplies';

final String rootCommentInfoUrl =
    'https://api-takumi.mihoyo.com/post/api/getRootReplyInfo';

//Post
// 发布回复
final String releaseReplyUrl =
    'https://api-takumi.mihoyo.com/post/api/releaseReply';

// 删除回复
final String deleteRelyUrl =
    'https://api-takumi.mihoyo.com/post/api/deleteReply';

/// POST [post-id] 帖子id
///{'is_cancel':false,'post_id':'814553'}
///stuid=;stoken=
final String upvotePostUrl =
    'https://api-takumi.mihoyo.com/apihub/sapi/upvotePost';

// 获取主题
final String getTopicFullInfoUrl =
    "https://api-static.mihoyo.com/takumi/topic/api/getTopicFullInfo";

// 获取主题
final String getTopicPostListUrl =
    "https://api-takumi.mihoyo.com/post/api/getTopicPostList";

// 发帖接口
String releasePostUrl = 'https://api-takumi.mihoyo.com/post/api/releasePost';

// 表情
String emotionsUrl = "https://api-takumi.mihoyo.com/misc/api/emoticon_set";

///[POST] {"ids":[193,192,177,185,182,132]}
//上传最近使用emoticons
String uploadRecentEmoticonUrl =
    'https://api-takumi.mihoyo.com/misc/api/recentlyEmoticon';

//============================================================================================================

// 先请获取验证信息再代入
//请求验证信息
final String uploadVertificationUrl =
    'https://api-takumi.mihoyo.com/apihub/sapi/getUploadParams';

// 上传图片
// String uploadImageUrl =
//     'https://mihoyo-community-web.oss-cn-shanghai.aliyuncs.com/';

//============================================================================================================

///获取所有论坛
/// [header_image] 为空就不能发贴
final String allGamesForumUrl =
    "https://api-takumi.mihoyo.com/apihub/api/getAllGamesForums";

//============================================================================================================
/// 关注
// 推荐的用户
final String recommendActiveUserListUrl =
    'https://api-community.mihoyo.com/community/user/Follow/recommendActiveUserList';

// 关注用户的帖子
final String followerPostUrl =
    'https://api-community.mihoyo.com/community/user/Follow/querytimeline';

//============================================================================================================
// GET IM即时通讯
final String getTimSigUrl = 'https://api-takumi.mihoyo.com/chat/api/getTIMSig';

final String getCharListUrl =
    'https://api-takumi.mihoyo.com/chat/api/getChatList?last_id=0&size=50';

//============================================================================================================
// 话题
final String followTopicUrl =
    'https://api-takumi.mihoyo.com/timeline/api/focus';

final String unFollowTopicUrl =
    'https://api-takumi.mihoyo.com/timeline/api/unfocus';

//============================================================================================================

//============================================================================================================
// 隐私设置
final String privacySettingUrl =
    'https://api-takumi.mihoyo.com/user/wapi/userPrivacySetting';
//============================================================================================================
final String bhLoginUrl = 'https://bbs.mihoyo.com/bh3/#/login';

//============================================================================================================
// 隐私设置
// ?gids=1&last_id=&page_size=20&type=1
final String getNewsListUrl =
    'https://api-takumi.mihoyo.com/post/api/getNewsList';
//============================================================================================================

final String myCenterUrl =
    'https://webstatic.mihoyo.com/app/community-shop/index.html?bbs_presentation_style=no_header#/miyobCenter';

final String myCoinRecordUrl =
    'https://webstatic.mihoyo.com/app/community-shop/index.html?bbs_presentation_style=no_header#/myb/miyobHistory/increase';

// 查找账号
final String findAccountUrl = 'https://user.mihoyo.com/#/findAccountGuide';
//

final String gameRecordsUrl =
    'https://webstatic.mihoyo.com/app/community-game-records/index.html?v=6#/';
