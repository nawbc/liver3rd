import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BhComicWrapper extends StatelessWidget {
  final String coverUrl;
  final Widget child;
  BhComicWrapper({this.coverUrl, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(45),
        right: ScreenUtil().setWidth(45),
        bottom: ScreenUtil().setHeight(35),
        top: ScreenUtil().setHeight(20),
      ),
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(500),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                ConstrainedBox(
                  //限制条件，可扩展的。
                  constraints: const BoxConstraints.expand(),
                  child: CachedNetworkImage(
                    imageUrl: coverUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Opacity(
                      opacity: 0.3,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey[400]),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
                child
              ],
            ),
          ),
        ),
      ),
    );
  }
}
