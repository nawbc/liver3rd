import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/widget/icons.dart';

class VideoCoverCard extends StatelessWidget {
  final Function onPressed;
  final String coverUrl;
  VideoCoverCard({this.onPressed, this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: ScreenUtil().setHeight(350),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: coverUrl,
              height: ScreenUtil().setHeight(300),
              fit: BoxFit.fitHeight,
            ),
            Center(
              child: CustomIcons.play(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
