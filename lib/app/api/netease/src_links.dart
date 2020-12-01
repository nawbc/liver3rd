String basicParseUrl(type, id) =>
    'https://api.imjad.cn/cloudmusic/?type=$type&id=$id';

String shareSongUrl(String id) => 'https://music.163.com/#/song?id=$id';

String playListUrl(String id) =>
    'https://music.163.com/api/playlist/detail?id=$id';
