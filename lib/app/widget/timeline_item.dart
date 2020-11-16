import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:uuid/uuid.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class Timeline extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String uid;
  final String code;
  final String description;
  final String expire;
  final String createAt;
  final Function(String) onTapAvatar;

  Timeline(
      {this.avatarUrl,
      this.username,
      this.uid,
      this.code,
      this.description,
      this.expire,
      this.createAt,
      this.onTapAvatar});

  void copyCode(context) {
    Clipboard.setData(ClipboardData(text: code));
    Scaffold.of(context).showSnackBar(CommonWidget.snack('已复制到剪贴板'));
  }

  @override
  Widget build(BuildContext context) {
    String heroTag = Uuid().v4();

    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: DecoratedBox(
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.only(
            top: 6,
            left: 8,
          ),
          child: Container(
            height: 270,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(130)),
                            border: Border.all(
                              width: 1,
                              color: Colors.blue[200],
                            ),
                          ),
                          child: Hero(
                            tag: heroTag,
                            child: GestureDetector(
                              onTap: () {
                                if (onTapAvatar != null) onTapAvatar(heroTag);
                              },
                              child: ClipOval(
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CachedNetworkImage(
                                    imageUrl: avatarUrl ?? '',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            NoScaledText(
                              username,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 2),
                            NoScaledText(
                              'UID: $uid',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 13),
                // 下半部分
                Padding(
                  padding: EdgeInsets.only(left: 35, right: 20),
                  child: Container(
                    width: double.infinity,
                    height: 170,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 4, color: Colors.blue[200]),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 15.0,
                              offset: Offset(6.0, 6.0),
                              spreadRadius: -6,
                            )
                          ],
                        ),
                        // 内容
                        child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 45),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                      ),
                                      height: 32,
                                      // 兑换码
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: SelectableText(
                                                code,
                                                autofocus: true,
                                                toolbarOptions: ToolbarOptions(
                                                  copy: true,
                                                  selectAll: true,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black26,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              icon: CustomIcons.copy,
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                copyCode(context);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: 85,
                                    child: Scrollbar(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.all(0.0),
                                        physics: BouncingScrollPhysics(),
                                        child: NoScaledText(
                                          '内容: $description',
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 16,
                                          ),
                                          // overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  NoScaledText(
                                    '过期时间:  ${expire?.substring(0, 19)}',
                                    style: TextStyle(
                                      color: Colors.red[400],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                  ),
                  child: NoScaledText(
                    '时间:  $createAt',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
