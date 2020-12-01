import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:uuid/uuid.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class FollowUserCard extends StatefulWidget {
  final String name;
  final int type;
  final String intro;
  final Function(String) onTap;
  final String avatarUrl;
  final String label;
  final Function onFollow;
  final bool isFollow;
  final String uid;

  FollowUserCard({
    Key key,
    this.name = '',
    this.type = 2,
    this.intro = '此人暂无介绍',
    this.avatarUrl = '',
    this.onTap,
    this.label = '',
    this.onFollow,
    this.isFollow = false,
    this.uid,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FollowUserCard();
  }
}

class _FollowUserCard extends State<FollowUserCard>
    with AutomaticKeepAliveClientMixin {
  bool _isFollowing;
  UserApi _userApi = UserApi();

  Function get onTap => widget.onTap;
  String get avatarUrl => widget.avatarUrl;
  String get name => widget.name;
  String get label => widget.label;
  int get type => widget.type;
  String get intro => widget.intro;
  bool get isFollow => widget.isFollow;
  Function get onFollow => widget.onFollow;
  String get uid => widget.uid;

  @override
  void initState() {
    super.initState();
    _isFollowing = isFollow;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width;
    String heroTag = Uuid().v1();
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap(heroTag);
      },
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.only(bottom: 5, top: 15, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Hero(
                        tag: heroTag,
                        child: ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            child: CachedNetworkImage(
                              imageUrl: avatarUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: screenWidth - 220,
                            child: NoScaledText(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          ),
                          Row(children: <Widget>[
                            CustomIcons.role(type, width: 20),
                            SizedBox(width: 10),
                            Container(
                              width: 110,
                              child: NoScaledText(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                  CommonWidget.button(
                    color: Color(0xff90caf9),
                    textStyle: TextStyle(fontSize: 16),
                    content: _isFollowing ? '已关注' : '关注',
                    width: 60,
                    onPressed: () async {
                      if (_isFollowing) {
                        await _userApi.unFollowUser(uid);

                        if (mounted) {
                          setState(() {
                            _isFollowing = false;
                          });
                        }
                      } else {
                        await _userApi.followUser(uid);

                        if (mounted) {
                          setState(() {
                            _isFollowing = true;
                          });
                        }
                      }
                      return [];
                    },
                  )
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
                textScaleFactor: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
