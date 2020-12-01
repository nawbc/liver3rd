import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/page/editors/account_editor.dart';
import 'package:liver3rd/app/page/editors/post_editor_page.dart';
import 'package:liver3rd/app/page/forum/forum_post_page.dart';
import 'package:liver3rd/app/page/forum/topic/topic_full_info_page.dart';
import 'package:liver3rd/app/page/forum/topic/topic_page.dart';
import 'package:liver3rd/app/page/forum/login_page.dart';
import 'package:liver3rd/app/page/forum/search/search_page.dart';
import 'package:liver3rd/app/page/forum/user/user_profile_page.dart';
import 'package:liver3rd/app/page/games/bh/bh_comic_content_page.dart';
import 'package:liver3rd/app/page/games/bh/bh_comic_page.dart';
import 'package:liver3rd/app/page/games/music_page.dart';
import 'package:liver3rd/app/page/games/music_player_page.dart';
import 'package:liver3rd/app/page/games/ys/ys_comic_content_page.dart';
import 'package:liver3rd/app/page/games/ys/ys_comic_page.dart';
import 'package:liver3rd/app/page/photo_view_page.dart';
import 'package:liver3rd/app/page/settings/about_page.dart';
import 'package:liver3rd/app/page/settings/forum_settings_msg_page.dart';
import 'package:liver3rd/app/page/settings/forum_settings_passport_page.dart';
import 'package:liver3rd/app/page/settings/forum_settings_privacy_page.dart';
import 'package:liver3rd/app/page/settings/settings_page.dart';
import 'package:liver3rd/app/page/shop/shop_present_detail.dart';
import 'package:liver3rd/app/page/editors/push_redemption_editor_page.dart';
import 'package:liver3rd/app/page/games/bh/bh_select_page.dart';
import 'package:liver3rd/app/page/games/bh/valkyries_page.dart';
import 'package:liver3rd/app/page/games/bh/wallpaper_page.dart';
import 'package:liver3rd/app/page/games/ys/ys_role_page.dart';
import 'package:liver3rd/app/page/inapp_purchase_page.dart';
import 'package:liver3rd/app/page/redemptions_page.dart';
import 'package:liver3rd/app/page/shop/shop_present_page.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/store/index.dart';
import 'package:liver3rd/app/page/main_page.dart';
import 'package:liver3rd/app/page/splash_page.dart';
import 'package:liver3rd/app/page/games/select_game_page.dart';
import 'package:liver3rd/app/page/games/ys/ys_select_page.dart';
import 'package:liver3rd/app/widget/bottom_dynamic_display_button.dart';
import 'package:liver3rd/app/widget/webview_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class LiverApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LiverAppState();
  }
}

BottomDynamicDisplayButton bddButton = BottomDynamicDisplayButton();

class _LiverAppState extends State<LiverApp> {
  @override
  void initState() {
    super.initState();

    Navigate.registerRoutes(
      routes: {
        'main': mainPageHandler,
        'splash': splashPageHandler,
        'redemptions': redemptionsPageHandler,
        'valkyries': valkyriesPageHandler,
        'ys': ysRolePageHandler,
        'setting': settingsPageHandler,
        'login': loginPageHandler,
        'switchgame': selectGamePageHandler,
        'bhselect': bhSelectPageHandler,
        'ysselect': ysSelectPageHandler,
        'bhcomic': bhComicPageHandler,
        'yscomic': ysComicPageHandler,
        'bhcomiccontent': bhComicContentPageHandler,
        'yscomiccontent': ysComicContentPageHandler,
        'musicplayer': musicPlayerPageHandler,
        'musicpage': musicPageHandler,
        'wallpaper': wallPaperPageHandler,
        'inapppurchase': inAppPurchaseHandler,
        'pushredemption': pushRedemptionEditorPageHandler,
        'shop': shopPresentPageHandler,
        'presentdetail': shopPresentDetailPageHandler,
        'photoviewpage': photoViewPageHandler,
        'post': forumPostPageHandler,
        'userprofile': userProfilePageHandler,
        'posteditor': userPostEditorPageHandler,
        'searchpage': searchPageHandler,
        'topic': topicPageHandler,
        'about': aboutPageHandler,
        'settingmsg': forumSettingsMsgPageHandler,
        'settingprivacy': forumSettingsPrivacyPageHandler,
        'settingpassport': forumSettingsPassportPagedler,
        'accounteditor': accountEditorPageHandler,
        'webview': webviewPageHandler,
        'topicinfo': topicFullInfoHandler,
        // 'inappwebview': inAppWebViewPageHandler
      },
      defualtTransactionType: TransactionType.fromBottom,
      beforeAllNavigate: () {
        bddButton?.remove();
      },
    );

    // 储存权限

    TinyUtils.checkPermissionAndRequest(PermissionGroup.storage);

    // 友盟
    // LcfarmFlutterUmeng.init(
    //   androidAppKey: UMENG_APP_KEY,
    //   channel: "test",
    //   logEnable: TinyUtils.isDev,
    // );

    // // 腾讯 IM
    // TencentImPlugin.init(
    //   appid: TENCENT_IM_APPID,
    //   logPrintLevel: LogPrintLevel.info,
    //   enabledLogPrint: TinyUtils.isDev,
    // );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // MaterialPageRoute(builder: null)

    return Storager.init(
      child: MediaQuery(
        ///不受系统字体缩放影响
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: MaterialApp(
          title: "肝肝肝",
          builder: BotToastInit(),
          navigatorObservers: <NavigatorObserver>[BotToastNavigatorObserver()],
          onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
            builder: (context) => Center(
              child: NoScaledText(
                '未知页面',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          home: SplashPage(),
          theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            // platform: TargetPlatform.iOS,
          ),
        ),
      ),
    );
  }
}
