import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcons {
  static Widget back(BuildContext context,
          {double width = 20, Color color = const Color(0xFF9E9E9E)}) =>
      IconButton(
        icon: SvgPicture.asset('assets/images/back.svg',
            color: color, width: width),
        padding: EdgeInsets.all(5),
        onPressed: () {
          Navigator.maybePop(context);
        },
      );

  static Widget user = SvgPicture.asset(
    'assets/images/user.svg',
    color: Colors.grey,
    width: 28,
  );

  static Widget pre = SvgPicture.asset(
    'assets/images/back.svg',
    color: Colors.grey,
    width: 24,
  );

  static Widget next = SvgPicture.asset(
    'assets/images/next.svg',
    color: Colors.grey,
    width: 24,
  );

  static Widget shop = SvgPicture.asset(
    'assets/images/shop.svg',
    color: Colors.grey,
    width: 26,
  );

  static Widget question = SvgPicture.asset(
    'assets/images/question.svg',
    width: ScreenUtil().setWidth(50),
    color: Colors.grey,
  );

  static Widget copy = SvgPicture.asset(
    'assets/images/copy.svg',
    color: Colors.black38,
    width: ScreenUtil().setWidth(60),
  );

  static Widget setting = SvgPicture.asset(
    'assets/images/setting.svg',
    color: Colors.grey,
    width: 28,
  );

  static Widget game = SvgPicture.asset(
    'assets/images/game.svg',
    color: Colors.grey,
    width: 30,
  );

  static Widget present = SvgPicture.asset(
    'assets/images/present.svg',
    width: 28,
    color: Colors.white,
  );

  static Widget male({double width = 15, Color color}) => SvgPicture.asset(
        'assets/images/male.svg',
        width: width,
        color: color,
      );

  static Widget female({double width = 15, Color color}) => SvgPicture.asset(
        'assets/images/female.svg',
        width: width,
        color: color,
      );

  static Widget unknown({double width = 15, Color color}) => SvgPicture.asset(
        'assets/images/question.svg',
        width: width,
        color: color,
      );

  static Widget home = SvgPicture.asset(
    'assets/images/home.svg',
    color: Colors.grey,
    width: 20,
  );

  static Widget comic = SvgPicture.asset(
    'assets/images/comic.svg',
    color: Colors.grey,
    width: 20,
  );

  static Widget community = SvgPicture.asset(
    'assets/images/community.svg',
    color: Colors.grey,
    width: 20,
  );

  static Widget loadErrorPicture = SvgPicture.asset(
    'assets/images/load_error.svg',
    width: ScreenUtil().setWidth(150),
  );

  static Widget play({Color color = Colors.grey}) => SvgPicture.asset(
        'assets/images/play.svg',
        width: 60,
        color: color,
      );

  static Widget pause({Color color = Colors.grey}) => SvgPicture.asset(
        'assets/images/pause.svg',
        width: 60,
        color: color,
      );

  static Widget downlaod = SvgPicture.asset(
    'assets/images/download.svg',
    width: ScreenUtil().setWidth(100),
    color: Colors.grey,
  );

  static Widget musicmode = SvgPicture.asset(
    'assets/images/music_mode.svg',
    width: ScreenUtil().setWidth(100),
    color: Colors.grey,
  );

  static Widget send({Color color = Colors.white}) => SvgPicture.asset(
        'assets/images/send.svg',
        width: 28,
        color: color,
      );

  static Widget comment({Color color}) => SvgPicture.asset(
        'assets/images/comment.svg',
        width: 23,
        color: color ?? Colors.grey[300],
      );
  static Widget eye({Color color}) => SvgPicture.asset(
        'assets/images/eye.svg',
        width: 23,
        color: color ?? Colors.grey[300],
      );

  static Widget like({Color color, double width = 23}) => SvgPicture.asset(
        'assets/images/like.svg',
        width: width,
        color: color ?? Colors.grey[300],
      );

  static Widget picture({double width = 30}) => SvgPicture.asset(
        'assets/images/picture.svg',
        width: width,
      );

  static Widget anchor({double width = 30}) => SvgPicture.asset(
        'assets/images/anchor.svg',
        width: width,
      );

  static Widget ship({double width = 30}) => SvgPicture.asset(
        'assets/images/ship.svg',
        width: width,
      );

  static Widget pointer({double width = 30}) => SvgPicture.asset(
        'assets/images/pointer.svg',
        width: width,
      );

  static Widget flower({double width = 30}) => SvgPicture.asset(
        'assets/images/flower.svg',
        width: width,
      );

  static Widget workspace({double width = 30}) => SvgPicture.asset(
        'assets/images/workspace.svg',
        width: width,
      );

  static Widget mirror({double width = 30}) => SvgPicture.asset(
        'assets/images/mirror.svg',
        width: width,
      );

  static Widget badge({double width = 30}) => SvgPicture.asset(
        'assets/images/badge.svg',
        width: width,
      );

  static Widget crown({double width = 30}) => SvgPicture.asset(
        'assets/images/crown.svg',
        width: width,
      );

  static Widget donut({double width = 30}) => SvgPicture.asset(
        'assets/images/donut.svg',
        width: width,
      );

  static Widget film({double width = 30}) => SvgPicture.asset(
        'assets/images/film.svg',
        width: width,
      );

  static Widget magnet({double width = 30}) => SvgPicture.asset(
        'assets/images/magnet.svg',
        width: width,
      );

  static Widget role(int type, {double width = 16}) {
    switch (type) {
      case 1:
        return SvgPicture.asset(
          'assets/images/badge.svg',
          width: width,
        );
      case 2:
        return SvgPicture.asset(
          'assets/images/star.svg',
          width: width,
        );
      default:
        return Container();
    }
  }

  static Widget bgColorIcon(String iconPath,
      {double width = 30,
      Color color = const Color(0xffff),
      EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
    return Container(
      width: 30,
      height: 30,
      padding: padding,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(width))),
      child: CachedNetworkImage(imageUrl: iconPath, fit: BoxFit.cover),
    );
  }
}
