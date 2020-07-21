import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TopicImageCard extends StatefulWidget {
  final double imgRate;
  final double marginX;
  final double marginY;
  final double avatarSize;
  final String nickName;
  final String introduce;
  final bool isUpvote;
  final bool Function(bool) onTapUpvote;
  final Function onTap;
  final Function(String) onTapAvatar;
  final String avatarUrl;
  final String coverUrl;
  final int likeNum;

  const TopicImageCard({
    Key key,
    this.imgRate = 1,
    this.avatarSize = 70,
    this.marginX = 15,
    this.marginY = 12,
    this.nickName = '',
    this.introduce = '',
    this.isUpvote = false,
    this.onTapUpvote,
    this.avatarUrl = '',
    this.coverUrl = '',
    this.onTap,
    this.onTapAvatar,
    this.likeNum,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TopicImageCardState();
  }
}

class _TopicImageCardState extends State<TopicImageCard>
    with AutomaticKeepAliveClientMixin {
  List<int> _filterColor = [150, 255, 255, 255];
  User _user;
  bool _colorLocker = false;
  bool _isUpvote;
  int _likedNum;

  @override
  void initState() {
    super.initState();
    _likedNum = widget.likeNum;
    _isUpvote = widget.isUpvote;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    if (!_colorLocker) {
      getColorFromUrl(widget.coverUrl).then((color) {
        if (color is List) {
          color.insert(0, 255);
          setState(() {
            _filterColor = color;
          });
        }
        _colorLocker = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double width = screenWidth - widget.marginX * 2;
    double height = width * widget.imgRate;
    String uuid = Uuid().v4();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15.0,
              offset: Offset(6.0, 6.0),
              spreadRadius: -6,
            )
          ],
        ),
        width: width,
        height: height,
        margin: EdgeInsets.only(
            right: widget.marginX,
            left: widget.marginX,
            top: widget.marginY,
            bottom: widget.marginY),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Stack(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: CachedNetworkImage(
                        imageUrl: widget.coverUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: 0.4,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                _filterColor[0],
                                _filterColor[1],
                                _filterColor[2],
                                _filterColor[3],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              // flex: 1,
              Container(
                color: Colors.white,
                height: 95,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      top: -35,
                      left: screenWidth / 2 -
                          widget.marginX -
                          widget.avatarSize / 2,
                      child: GestureDetector(
                        onTap: () {
                          widget.onTapAvatar(uuid);
                        },
                        child: Container(
                          width: widget.avatarSize,
                          height: widget.avatarSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(70)),
                          ),
                          child: Hero(
                            tag: uuid,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: widget.avatarUrl,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 5),
                                width: screenWidth - widget.marginX - 100,
                                alignment: Alignment.center,
                                child: Text(
                                  widget.nickName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: screenWidth / 2,
                                alignment: Alignment.center,
                                child: Text(
                                  widget.introduce,
                                  overflow: TextOverflow.ellipsis,
                                  // softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 20),
                        child: Transform.translate(
                          offset: Offset(0, 3),
                          child: Text(
                            '$_likedNum',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.onTapUpvote != null &&
                              widget.onTapUpvote(_isUpvote)) {
                            setState(() {
                              _isUpvote ? _likedNum-- : _likedNum++;
                              _isUpvote = !_isUpvote;
                            });
                          }
                        });
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10, right: 20),
                          child: Transform.translate(
                            offset: Offset(0, 3),
                            child: _isUpvote
                                ? CustomIcons.like(color: Colors.red, width: 22)
                                : CustomIcons.like(width: 22),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
