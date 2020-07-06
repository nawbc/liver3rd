import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PresentCard extends StatelessWidget {
  final String heroTag;
  final String goodsName;
  final int accountCycleLimit;
  final int accountExchangeNum;
  final String coverImgUrl;
  final Function onPressed;
  final int total;
  final bool unlimit;
  final int price;
  final int type;

  const PresentCard({
    Key key,
    this.heroTag,
    this.goodsName,
    this.accountCycleLimit,
    this.accountExchangeNum,
    this.total,
    this.unlimit,
    this.price,
    this.onPressed,
    this.type,
    this.coverImgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(width: 1, color: Colors.grey[200]),
      ),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(40),
        right: ScreenUtil().setWidth(40),
        bottom: ScreenUtil().setWidth(50),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onPressed,
        child: Container(
          height: ScreenUtil().setHeight(290),
          width: double.infinity,
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Hero(
                  tag: heroTag,
                  child: CachedNetworkImage(
                    imageUrl: coverImgUrl ?? '',
                    width: ScreenUtil().setHeight(260),
                    height: ScreenUtil().setHeight(270),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(5),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Stack(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    fit: StackFit.expand,
                    children: <Widget>[
                      Text(
                        goodsName,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(45),
                          color: Colors.grey,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '限购 $accountExchangeNum/$accountCycleLimit',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: ScreenUtil().setSp(35),
                          ),
                        ),
                      ),
                      if (unlimit)
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(right: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    '$price',
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
                                '库存 ${type == 1 ? total : '∞'}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: ScreenUtil().setSp(35),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
