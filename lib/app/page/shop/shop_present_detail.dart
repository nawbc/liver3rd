import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/api/shop/shop_api.dart';
import 'package:liver3rd/app/page/shop/widget/order_drawer.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class PresentDetailPage extends StatefulWidget {
  final String coverImgUrl;
  final String heroTag;
  final String goodsName;
  final int total;
  final bool unlimit;
  final int accountCycleLimit;
  final int accountExchangeNum;
  final int price;
  final int type;
  final int appId;
  final String goodsId;
  final String pointSn;
  PresentDetailPage({
    Key key,
    this.heroTag,
    this.goodsName,
    this.total,
    this.unlimit,
    this.accountCycleLimit,
    this.accountExchangeNum,
    this.price,
    this.type,
    this.coverImgUrl,
    this.appId,
    this.goodsId,
    this.pointSn,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PresentDetailPageState();
  }
}

class _PresentDetailPageState extends State<PresentDetailPage> {
  ShopApi _shopApi = ShopApi();
  Map _detailData = {};

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_detailData.isEmpty) {
      Map data = await _shopApi.fetchPresentDetail(
        appId: widget.appId,
        goodsId: widget.goodsId.toString(),
        pointSn: widget.pointSn,
      );
      if (mounted) {
        setState(() {
          _detailData = data;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _detailData = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(20)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Hero(
              tag: widget.heroTag,
              child: CachedNetworkImage(
                imageUrl: widget.coverImgUrl,
                width: double.infinity,
              ),
            ),
            Container(
              // color: Colors.red,
              width: double.infinity,
              height: ScreenUtil().setHeight(260),
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                fit: StackFit.expand,
                children: <Widget>[
                  Text(
                    widget.goodsName,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(55),
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '限购 ${widget.accountExchangeNum}/${widget.accountCycleLimit}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: ScreenUtil().setSp(35),
                        ),
                      ),
                    ),
                  ),
                  if (widget.unlimit)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.rotate(
                        angle: pi / 8,
                        child: Text(
                          '已售罄',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(60),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(right: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '${widget.price}',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: ScreenUtil().setSp(50),
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setHeight(10)),
                                Text(
                                  '米游币',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(35),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '库存${widget.type == 1 ? widget.total : '∞'}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: ScreenUtil().setSp(35),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              height: ScreenUtil().setHeight(1400),
              child: _detailData.isEmpty
                  ? CommonWidget.loading()
                  : Html(data: _detailData['data']['goods_detail']),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(120),
        child: RaisedButton(
          color: Colors.blue[200],
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) => OrderDarwer(),
            );
          },
          child: Text(
            '立即兑换',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(50),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

var shopPresentDetailPageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return PresentDetailPage(
      coverImgUrl: arg['coverImgUrl'],
      heroTag: arg['heroTag'],
      goodsName: arg['goodsName'],
      accountCycleLimit: arg['accountCycleLimit'],
      accountExchangeNum: arg['accountExchangeNum'],
      total: arg['total'],
      unlimit: arg['unlimit'],
      price: arg['price'],
      type: arg['type'],
      appId: arg['appId'],
      goodsId: arg['goodsId'],
      pointSn: arg['pointSn'],
    );
  },
);
