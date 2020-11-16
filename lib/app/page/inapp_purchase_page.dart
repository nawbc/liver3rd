import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class PayCard extends StatelessWidget {
  final Color buttonColor;
  final Function onPressed;
  final String text;
  final String imgUrl;
  final double textSize;
  PayCard({
    this.buttonColor,
    this.onPressed,
    this.text,
    this.imgUrl,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
            child: NoScaledText(
              text,
              softWrap: true,
              style: TextStyle(color: Colors.grey[400], fontSize: textSize),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Image.asset(imgUrl),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(100),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RaisedButton(
                    color: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    onPressed: onPressed != null ? onPressed : () {},
                    child: NoScaledText(
                      '跳转(不支付也能解锁)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(50),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class InAppPurchase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InAppPurchasePageState();
  }
}

class _InAppPurchasePageState extends State<InAppPurchase> {
  TabController _controller;
  String _readme = '支持下, 开发掉头。会自动保存二维码到相册, 之后自行删除     蹦蹦蹦NB';
  String _notication = '支付宝可能无法弹出转账界面， 可以使用扫一扫';

  List<Tab> _inAppPurchaseTabList = [
    Tab(
      child: NoScaledText(
        '微信',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[700],
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: NoScaledText(
        '支付宝',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[700],
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];

  Future<void> _saveQr(String url,
      {Function onSuccess, Function onError}) async {
    ByteData data = await rootBundle.load(url);
    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(data.buffer.asUint8List()));
    if (result != null) {
      if (onSuccess != null) {
        onSuccess();
      }
    } else {
      onError();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: _inAppPurchaseTabList.length,
      vsync: ScrollableState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(0),
      ),
      backgroundColor: Colors.white,
      bottomSheet: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: TabBar(
            tabs: _inAppPurchaseTabList,
            controller: _controller,
            indicatorPadding: EdgeInsets.all(0),
            indicator: PointTabIndicator(
              position: PointTabIndicatorPosition.bottom,
              color: Colors.blue[200],
              insets: EdgeInsets.only(bottom: 6),
            ),
          ),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return TabBarView(
          controller: _controller,
          children: [
            PayCard(
              buttonColor: Colors.green,
              textSize: ScreenUtil().setSp(50),
              imgUrl: 'assets/images/wechatpay.jpg',
              onPressed: () async {
                await Share.setBool(IS_PURCHASE, true);
                _saveQr('assets/images/wechatpay.jpg', onSuccess: () {
                  Scaffold.of(context)
                      .showSnackBar(CommonWidget.snack('二维码以保存到手机相册'));
                }, onError: () {
                  Scaffold.of(context).showSnackBar(
                      CommonWidget.snack('二维码保存失败', isError: true));
                });
                Timer(Duration(seconds: 1), () {
                  TinyUtils.openUrl('weixin://', error: () {
                    Scaffold.of(context).showSnackBar(
                        CommonWidget.snack('跳转失败', isError: true));
                  });
                });
              },
              text: _readme,
            ),
            PayCard(
              buttonColor: Colors.blue,
              imgUrl: 'assets/images/alipay.jpg',
              textSize: ScreenUtil().setSp(50),
              onPressed: () async {
                await Share.setBool(IS_PURCHASE, true);
                _saveQr('assets/images/alipay.jpg', onSuccess: () {
                  Scaffold.of(context).showSnackBar(
                      CommonWidget.snack('二维码以保存到手机相册', isError: true));
                }, onError: () {
                  Scaffold.of(context).showSnackBar(
                      CommonWidget.snack('二维码保存失败', isError: true));
                });
                Timer(Duration(seconds: 1), () async {
                  TinyUtils.openUrl(
                      'alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/tsx12024wt2admr8ftunwe4',
                      // 'alipays://platformapi/startapp?appId=09999988&actionType=toAccount&goBack=NO&userId=2088722095158050&amount=3',
                      error: () {
                    Scaffold.of(context).showSnackBar(
                        CommonWidget.snack('跳转失败', isError: true));
                  });
                });
              },
              text: _notication,
            ),
          ],
        );
      }),
    );
  }
}

var inAppPurchaseHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return InAppPurchase();
  },
);
