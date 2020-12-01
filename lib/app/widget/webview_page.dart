import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/base_url.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/api/utils.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

void webNavigationHandler(BuildContext context, String url,
    {Map val = const {}, bool isLogin}) {
  if (url.contains('comic') && url.contains('bh3')) {
    Navigate.navigate(context, 'bhcomic');
    return;
  }

  Uri uri = Uri.parse(url);

  switch (uri.scheme) {
    case 'https':
    case 'http':
      if (isLogin) {
        Navigate.navigate(context, 'webview', arg: {
          'title': val['name'],
          'url': val['app_path'],
        });
      } else {
        Navigate.navigate(context, 'login');
      }
      break;
    case 'mihoyobbs':
      switch (uri.host) {
        case 'article':
          if (uri.pathSegments.isNotEmpty) {
            Navigate.navigate(context, 'post',
                arg: {'postId': uri.pathSegments[0]});
          }
          break;
        case 'forum':
          if (uri.pathSegments.isNotEmpty) {
            Navigate.navigate(
              context,
              'topic',
              arg: {
                'forum_id': uri.pathSegments[0] is String
                    ? int.parse(uri.pathSegments[0])
                    : null,
              },
            );
          }
          break;
        case 'discussion':
          if (uri.pathSegments.isNotEmpty) {
            Navigate.navigate(
              context,
              'topic',
              arg: {
                'src_type': uri.pathSegments[0] is String
                    ? int.parse(uri.pathSegments[0])
                    : null,
                'forum_id': int.parse(uri.queryParameters['forum_id'])
              },
            );
          }
          break;
        case 'webview':
          String link = uri.queryParameters['link'];
          Navigate.navigate(
            context,
            'webview',
            arg: {'url': link},
          );
          break;
        default:
      }
      break;
    default:
      BotToast.showText(text: '功能未实现');
      break;
  }
}

class WebviewPage extends StatefulWidget {
  final String url;
  final String inject;
  final String title;
  final Map<String, String> headers;
  final dynamic withAppBar;
  WebviewPage({
    this.url = '',
    this.inject = '',
    this.title = '',
    this.headers,
    this.withAppBar,
  });

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController _webController;
  GlobalModel _globalModel;
  UserApi _userApi = UserApi();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _webController = null;
  }

  Future<void> setUserCookie() async {
    final cookieManager = WebviewCookieManager();
    await cookieManager.setCookies(
      [
        (Cookie('account_id', _globalModel.userInfo['uid'])
          ..domain = '.mihoyo.com'
          ..httpOnly = false),
        (Cookie('cookie_token', _globalModel.userInfo['cookieToken'])
          ..domain = '.mihoyo.com'
          ..httpOnly = false),
      ],
    );
  }

  JavascriptChannel _loginJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Login',
      onMessageReceived: (JavascriptMessage message) async {
        final cookieManager = WebviewCookieManager();
        List getCookies = await cookieManager.getCookies(bbsUrl);

        String uid, webLoginToken;
        for (Cookie item in getCookies) {
          if (item.name == 'account_id') {
            uid = item.value;
          }

          if (item.name == 'login_ticket') {
            webLoginToken = item.value;
          }
        }
        if (uid == null && webLoginToken == null) {
          return;
        }

        _userApi
            .fetchAllTokens(uid: uid, webLoginToken: webLoginToken)
            .then((tokens) async {
          // 这里获取，跳转后_user.info 就已经带有数据了
          List tokenList = tokens['data']['list'];
          // 存到本地
          await TinyUtils.saveTokenToLocal(
            stoken: tokenList[0]['token'],
            ltoken: tokenList[1]['token'],
            uid: uid,
            webLoginToken: webLoginToken,
          );
          await _globalModel.getUserFullInfo();
          if (_globalModel.userInfo.isNotEmpty &&
              _globalModel.userInfo['data'] != null) {
            _globalModel.setLogin(true);
            await Future.delayed(Duration(seconds: 1));
            Navigate.navigate(context, 'main', replaceRoute: ReplaceRoute.all);
            // Navigator.popUntil(context, ModalRoute.withName('/main'));
          } else {
            BotToast.showText(text: '登陆失败，请重新登陆');
          }
        }).catchError((err) {
          BotToast.showText(text: 'token 获取错误');
        });
      },
    );
  }

  JavascriptChannel _injectMihoyoChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'MiHoYoJSInterface',
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        try {
          dynamic payload = json.decode(message.message)['payload'];
          if (payload != null && payload['page'] is String) {
            webNavigationHandler(context, payload['page']);
          }
        } catch (e) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('webview ========================================');
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: widget.withAppBar == null
      //     ? AppBar(
      //         title: GestureDetector(
      //           onTap: () async {
      //             await _webController?.evaluateJavascript(widget.inject);
      //           },
      //           child: CommonWidget.titleText(widget.title),
      //         ),
      //         centerTitle: true,
      //         leading: CustomIcons.back(context),
      //         elevation: 0,
      //       )
      //     : null,
      body: SafeArea(
        child: WebView(
          userAgent: webviewUserAgent,
          javascriptChannels: <JavascriptChannel>[
            _loginJavascriptChannel(context),
            _injectMihoyoChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            print('@@@@@@@@@@@@@@@@@@@@@${request.url}');
            if (request.url.startsWith('uniwebview')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _webController = webViewController;

            if (_globalModel.userInfo['cookieToken'] != null) {
              await setUserCookie();
            }

            if (widget.headers != null) {
              _webController.loadUrl(widget.url, headers: widget.headers);
            } else {
              _webController.loadUrl(
                widget.url,
              );
            }
          },
          onPageFinished: (String url) async {
            if (widget.inject != null) {
              await _webController?.evaluateJavascript(widget.inject);
            }
          },
        ),
      ),
    );
  }
}

Handler webviewPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return WebviewPage(
      url: arg['url'],
      inject: arg['inject'],
      title: arg['title'],
      headers: arg['headers'],
      withAppBar: arg['withAppBar'],
    );
  },
);
