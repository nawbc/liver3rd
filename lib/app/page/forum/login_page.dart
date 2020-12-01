import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/api/forum/src_links.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/store/global_model.dart';

import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  UserApi _userApi = UserApi();
  GlobalModel _globalModel;
  int _countdown = 59;
  bool _isClickedSend = false;
  Timer _captchaTimer;

  @override
  void initState() {
    super.initState();
    _globalModel = Provider.of<GlobalModel>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    if (_captchaTimer != null) {
      _captchaTimer.cancel();
      _captchaTimer = null;
    }
  }

  Future<void> _sendMobileCaptcha(BuildContext context) async {
    if (TinyUtils.isLegalChinesePN(_phoneController.text)) {
      Map data = await _userApi.createMobileCaptcha(_phoneController.text);
      if (data['data']['status'] == 1) {
        setState(() {
          _isClickedSend = true;
        });
        _startCountdown();
      }
      Scaffold.of(context)
          .showSnackBar(CommonWidget.snack(data['data']['msg']));
      return data['data']['msg'];
    } else {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('输入正确的手机号'));
    }
  }

  Future<void> _login(BuildContext context) async {
    if (_captchaController.text == '' && _phoneController.text == '') {
      Scaffold.of(context).showSnackBar(CommonWidget.snack('请输入'));
      return;
    }
    //收起鍵盤
    FocusScope.of(context).requestFocus(FocusNode());

    Map data = await _userApi.sendCapcha(
        _phoneController.text, _captchaController.text);

    try {
      var info = data['data']['account_info'];
      if (info == null) {
        Scaffold.of(context).showSnackBar(
            CommonWidget.snack('${data['data']['msg']}', isError: true));
        setState(() {
          _isClickedSend = false;
        });
      } else {
        String webLoginToken = info['weblogin_token'];
        String uid = info['account_id'].toString();
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
            Navigate.navigate(context, 'main');
          } else {
            BotToast.showText(text: '登陆失败，请重新登陆');
          }
        }).catchError((err) {
          BotToast.showText(text: 'token 获取错误');
          setState(() {
            _isClickedSend = false;
          });
        });
      }
    } catch (err) {
      BotToast.showText(text: '数据解析错误');
      setState(() {
        _isClickedSend = false;
      });
    }
  }

  void _startCountdown() {
    if (_captchaTimer != null) {
      return;
    }
    _captchaTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      if (_countdown <= 0) {
        setState(() {
          _isClickedSend = false;
          _countdown = 59;
        });
        _captchaTimer.cancel();
        _captchaTimer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomIcons.back(context),
          elevation: 0,
          title: CommonWidget.titleText('登录'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 10,
                          ),
                          child: CustomIcons.question,
                        ),
                        NoScaledText(
                          '请使用米游社区账号登录',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(40),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            TinyUtils.openUrl(
                              bhLoginUrl,
                              error: () {
                                Scaffold.of(context).showSnackBar(
                                  CommonWidget.snack('链接跳转失败'),
                                );
                                FLog.error(
                                  text: 'open url error',
                                  className: 'LoginPage',
                                );
                              },
                            );
                          },
                          child: NoScaledText(
                            '注册',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: ScreenUtil().setSp(40),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    CommonWidget.borderTextField(
                      height: 51,
                      hintText: '请输入手机号',
                      keyboardType: TextInputType.phone,
                      textController: _phoneController,
                      withBorder: true,
                    ),
                    SizedBox(height: 17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CommonWidget.borderTextField(
                          width: 110,
                          height: 51,
                          hintText: '验证码',
                          keyboardType: TextInputType.phone,
                          textController: _captchaController,
                        ),
                        SizedBox(width: 10),
                        _isClickedSend
                            ? Container(
                                height: 51,
                                width: 51,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.grey[400]),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: NoScaledText(
                                    '$_countdown',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(45),
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 51,
                                width: 70,
                                child: Builder(
                                  builder: (context) {
                                    return RaisedButton(
                                      elevation: 3,
                                      child: NoScaledText(
                                        '获取',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () =>
                                          _sendMobileCaptcha(context),
                                      color: Colors.blue[200],
                                      colorBrightness: Brightness.dark,
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Container(
                          width: 220,
                          height: 51,
                          child: Builder(
                            builder: (BuildContext context) {
                              return RaisedButton(
                                elevation: 0,
                                child: NoScaledText(
                                  '登录',
                                  style: TextStyle(fontSize: 20),
                                ),
                                color: Colors.blue[200],
                                colorBrightness: Brightness.dark,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                onPressed: () => _login(context),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            String jsString = await rootBundle
                                .loadString('assets/javascript/loginInject.js');
                            Navigate.navigate(context, 'webview', arg: {
                              'title': '登录',
                              'url': 'https://m.bbs.mihoyo.com/bh2/#/login',
                              'inject': jsString,
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: NoScaledText(
                              '使用网页登录',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: ScreenUtil().setSp(40),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Handler loginPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return LoginPage();
  },
);
