import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liver3rd/app/page/games/bh/widget/bh_comic_wrapper.dart';

class BhComicIntroCard extends StatelessWidget {
  final String coverUrl;
  final String title;
  final String description;
  BhComicIntroCard({this.coverUrl, this.description, this.title});

  @override
  Widget build(BuildContext context) {
    // container height 500
    return BhComicWrapper(
      coverUrl: coverUrl,
      child: Container(
        padding: EdgeInsets.all(
          ScreenUtil().setWidth(35),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                constraints: BoxConstraints.expand(),
                child: Stack(
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(60),
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: coverUrl,
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(500),
                          height: ScreenUtil().setHeight(300),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                ),
                physics: BouncingScrollPhysics(),
                child: Text(
                  description,
                  softWrap: true,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
