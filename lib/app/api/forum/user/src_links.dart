///==========================================================================================================================================================
///用戶
///==========================================================================================================================================================

/// 密码登录
///https://api-takumi.mihoyo.com/auth/api/getMultiTokenByLoginTicket?uid=81092022&login_ticket=Ck74YCPbR7Yur6XO68WtOaNc3sY6m7NM1yBmEcKT&token_types=3
/// https://webapi.account.mihoyo.com/Api/create_mmt
/// {"code":200,"data":{"mmt_data":{"challenge":"50645932629714f538fcec76634969d0","gt":"ae0942d9463f21fb73d27d49ed2f1154","mmt_key":"VjwwnQwDD94sCcIWstN2GsrXUq5V9a2W","new_captcha":1,"success":1},"mmt_type":1,"msg":"成功","scene_type":1,"status":1}}
///
/// https://static.geetest.com/static/appweb/app3-index.html?gt=ae0942d9463f21fb73d27d49ed2f1154&challenge=50645932629714f538fcec76634969d0&lang=zh-CN&title=&type=slide&api_server=api.geetest.com&static_servers=static.geetest.com,%20dn-staticdown.qbox.me&width=100%&timeout=10000&debug=false&aspect_radio_voice=128&aspect_radio_pencil=128&aspect_radio_slide=103&aspect_radio_click=128&aspect_radio_beeline=50&voice=/static/js/voice.1.2.0.js&pencil=/static/js/pencil.1.0.3.js&slide=/static/js/slide.7.7.0.js&click=/static/js/click.2.8.9.js&beeline=/static/js/beeline.1.0.1.js
// 验证码
String getMobileCaptchaUrl(String phoneNum) =>
    'https://webapi.account.mihoyo.com/Api/create_mobile_captcha?action_type=login&mobile=$phoneNum&action_ticket=';

///验证capcha
///{"code":200,"data":{"account_info":{"account_id":81092022,"area_code":"+86","create_time":1578273699,"identity_code":"341************011","is_adult":1,"mobile":"153****7602","real_name":"*涵","safe_level":2,"weblogin_token":"0eTXPytiz75wZ7DvGHYvRiTeuGddfjuyHDFKt7iV"},"msg":"成功","status":1}}
String checkCaptchaUrl(String phoneNum, String captcha) =>
    'https://webapi.account.mihoyo.com/Api/login_by_mobilecaptcha?mobile=$phoneNum&mobile_captcha=$captcha';

/// 根据weblogin_token获取
String getTokenUrl(String uid, String webToken) =>
    'https://api-takumi.mihoyo.com/auth/api/getMultiTokenByLoginTicket?uid=$uid&login_ticket=$webToken&token_types=3';

//Cookie:	UM_distinctid=170c0140a0f2f3-00339bb7f93e93-3a36560e-1fa400-170c0140a10333; _ga=GA1.2.1981425614.1583997794; _gid=GA1.2.337770877.1583997794; acw_tc=2f624a5c15840682787575870e6bff48487854ebc695062bd7f2e7c3ee1f27
/// 获取用户登录信息
String userInfoUrl(String uid) =>
    'https://api-takumi.mihoyo.com/user/api/getUserFullInfo?uid=$uid';

///[GET]
// 用户的帖子列表
final String userPostListUrl =
    'https://api-community.mihoyo.com/community/user/userPost/postList';

///[GET]
///用户收藏
final String userFavoritePostListUrl =
    'https://api-community.mihoyo.com/community/user/userPost/favoritePostList';

///[GET]
///用户回复
final String userReplyListUrl =
    'https://api-community.mihoyo.com/community/user/userPost/replyList';

///[GET]
// 获取任务
final String missionsUrl =
    'https://api-takumi.mihoyo.com/apihub/wapi/getMissions?app_id=1&point_sn=myb';

///[GET]
// 任务状态
final String missionsStateUrl =
    'https://api-takumi.mihoyo.com/apihub/wapi/getUserMissionsState?app_id=1&point_sn=myb';

///[POST]
/// 签到  {"gids":"1"}
final String signInUrl = 'https://api-takumi.mihoyo.com/apihub/sapi/signIn';

/// 关注
/// String [entity_id] 用户的id
final String followUserUrl =
    'https://api-takumi.mihoyo.com/timeline/api/follow';

/// 取消关注
/// [entity_id] 用户的id
final String unFollowUserUrl =
    'https://api-takumi.mihoyo.com/timeline/api/unfollow';

final String editUserInfoUrl =
    'https://api-takumi.mihoyo.com/user/wapi/userInfoEdit';

//设置头像
final String setUserAvatarsUrl =
    'https://api-static.mihoyo.com/takumi/misc/wapi/avatar_set';
