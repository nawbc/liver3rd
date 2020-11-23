///[channelId] 171 最新， 172 动态，  173 公告， 174 活动 , 175 补给 ， 177 壁纸 ， 179 动画  , 181 女武神
String contentListUrl(channelId) =>
    'https://www.bh3.com/content/bh3Cn/getContentList?pageSize=2000&pageNum=1&channelId=$channelId';

String contentUrl(contentId) =>
    'https://www.bh3.com/content/bh3Cn/getContent?contentId=$contentId&around=1';

///==========================================================================================================================================================
///webview
///==========================================================================================================================================================
final String raidersUrl = 'https://m.bbs.mihoyo.com/bh3/#/home/14';
final String armsUrl = 'http://m.3rdguide.com/ap/arm/index';
final String stigmaUrl = 'http://m.3rdguide.com/ap/stig/index';
String valkyrieDetail(String id) =>
    'http://m.3rdguide.com/ap/valk/detail?id=$id';

///==========================================================================================================================================================
///漫画
///==========================================================================================================================================================
// 漫画列表
final String comicsListUrl = 'https://comic.bh3.com/book';

final String comicsCollectionCoverUrl =
    'https://comicstatic.bh3.com/new_static_v2/comic/chapter_cover/';

/// 官方资讯
/// [type] 1公告 2 活动 3资讯
/// cookie
String officeNewsUrl(int gid, int type, int lastId) =>
    'https://api-community.mihoyo.com/community/forum/home/news?type=$type&page_size=20&last_id=$lastId&gids=$gid';
