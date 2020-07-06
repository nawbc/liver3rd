String realVideoUrl(int cid, String bvid) =>
    'https://api.bilibili.com/x/player/playurl?cid=$cid&bvid=$bvid';

String videoCidByBvidUrl(String bvid) =>
    'https://api.bilibili.com/x/player/pagelist?bvid=$bvid';

String videoAidUrl(String bvid, int cid) =>
    'https://api.bilibili.com/x/web-interface/view?cid=$cid&bvid=$bvid';

String videoCidByAidUrl(int aid) =>
    'https://api.bilibili.com/x/web-interface/view?aid=$aid';
