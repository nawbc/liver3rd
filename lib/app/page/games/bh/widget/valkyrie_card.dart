import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ValkyrieCard extends StatelessWidget {
  final String coverUrl;
  final String valkyrieName; //符华
  final String armorName; //云墨丹心
  final String combatMode;
  final String intro;
  final String avatarUrl;
  final String backgroundImgUrl;
  final String birthday;
  final List<Map<String, String>> skills;
  final int total;
  final Color backgroundColor;

  const ValkyrieCard(
      {Key key,
      this.coverUrl,
      this.valkyrieName,
      this.armorName,
      this.combatMode,
      this.intro,
      this.avatarUrl,
      this.backgroundImgUrl,
      this.birthday,
      this.skills,
      this.total,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(40),
        right: ScreenUtil().setWidth(40),
        bottom: ScreenUtil().setHeight(60),
        top: ScreenUtil().setHeight(450),
      ),
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(2.0, 2.0),
              blurRadius: 4.0,
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              top: -ScreenUtil().setHeight(415),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                width: ScreenUtil().setWidth(640),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(240),
                    child: CachedNetworkImage(
                      // 背景图片
                      imageUrl: backgroundImgUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(65),
                    right: ScreenUtil().setWidth(65),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        armorName,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(80),
                          color: Colors.white,
                          shadows: [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(1.0, 1.0),
                                blurRadius: 4.0)
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Text(
                        '姓名:  $valkyrieName',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                            color: Colors.white),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      Text(
                        '生日:  $birthday',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      Text(
                        '装甲:  $armorName',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                            color: Colors.white),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      Text(
                        '作战方式:  $combatMode',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: ScreenUtil().setWidth(240),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: skills.map(
                    (ele) {
                      return SizedBox(
                        width: ScreenUtil().setWidth(150),
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: ele['icon'],
                              height: ScreenUtil().setWidth(150),
                              width: ScreenUtil().setWidth(150),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(5),
                            ),
                            Text(
                              ele['name'],
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
