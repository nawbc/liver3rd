import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:uuid/uuid.dart';

class FollowUserCard extends StatelessWidget {
  final Color randomColor;
  final String name;
  final int type;
  final String intro;
  final Function(String) onTap;
  final String avatarUrl;
  final String label;
  final Function onFollow;

  const FollowUserCard({
    Key key,
    this.randomColor = const Color(0xff90caf9),
    this.name = '',
    this.type = 2,
    this.intro = '此人暂无介绍',
    this.avatarUrl = '',
    this.onTap,
    this.label = '',
    this.onFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String heroTag = Uuid().v1();
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap(heroTag);
      },
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.only(bottom: 5, top: 15, left: 25, right: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.grey[400]),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: heroTag,
                    child: ClipOval(
                      child: Container(
                        width: screenWidth / 6,
                        height: screenWidth / 6,
                        child: CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: screenWidth - 220,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 22, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(children: <Widget>[
                          CustomIcons.role(type, width: 20),
                          SizedBox(width: 10),
                          Container(
                            width: 110,
                            child: Text(
                              label,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ]),
                      ])
                ],
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: '介绍: ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  TextSpan(
                    text: intro,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ]),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: screenWidth / 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 10, color: randomColor),
                          SizedBox(height: 8),
                          Container(
                              height: 10,
                              width: screenWidth / 6,
                              color: randomColor),
                        ]),
                  ),
                  CommonWidget.button(
                    color: randomColor,
                    textStyle: TextStyle(fontSize: 16),
                    content: '关注',
                    width: 60,
                    onPressed: onFollow,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}