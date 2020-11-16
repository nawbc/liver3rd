import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

import 'package:liver3rd/app/widget/icons.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class UserProfileLabel extends StatelessWidget {
  final Function(String heroTag) onAvatarTap;
  final String avatarUrl;
  final String nickName;
  final Widget title;
  final Widget subTitle;
  final int certificationType;
  final dynamic createAt;
  final int level;
  final Widget Function() extend;
  final String heroTagOutside;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double avatarSize;

  String heroTag = Uuid().v1();

  UserProfileLabel({
    Key key,
    this.onAvatarTap,
    @required this.avatarUrl,
    this.nickName,
    this.certificationType,
    this.createAt,
    this.level,
    this.extend,
    this.title,
    this.subTitle,
    this.heroTagOutside,
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.avatarSize = 47,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onAvatarTap != null) onAvatarTap(heroTag);
      },
      child: Container(
        height: 70,
        margin: margin ?? EdgeInsets.all(0),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: heroTag,
                  child: ClipOval(
                    child: Container(
                      height: avatarSize,
                      width: avatarSize,
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl != null ? avatarUrl : '',
                        width: avatarSize,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            title ??
                                NoScaledText(
                                  nickName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                            if (level != null) ...[
                              SizedBox(width: 8),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                                height: 18,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: NoScaledText(
                                  'Lv$level',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      Container(
                        child: subTitle ??
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                NoScaledText(
                                  createAt is String
                                      ? createAt
                                      : DateTime.fromMillisecondsSinceEpoch(
                                              createAt * 1000)
                                          .toString()
                                          .substring(5, 16),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                SizedBox(width: 8),
                                CustomIcons.role(certificationType),
                              ],
                            ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (extend != null) extend()
          ],
        ),
      ),
    );
  }
}
