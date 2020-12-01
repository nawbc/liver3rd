import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/store/global_model.dart';

import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  final Function onDrawerTap;
  final Function onSwitchGameTap;
  final Function onSettingTap;
  final Function onHomeTap;
  final Function onForumTap;

  BottomBar({
    this.onDrawerTap,
    this.onSwitchGameTap,
    this.onSettingTap,
    this.onHomeTap,
    this.onForumTap,
  })  : assert(onDrawerTap != null),
        assert(onSettingTap != null),
        assert(onSettingTap != null),
        assert(onForumTap != null);

  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  GlobalModel _globalModel;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);
  }

  dynamic userAvatarUrl() {
    return _globalModel.isLogin
        ? _globalModel.userInfo['data']['user_info']['avatar_url']
        : null;
  }

  dynamic getUsername() {
    return _globalModel.isLogin
        ? _globalModel.userInfo['data']['user_info']['nickname']
        : null;
  }

  @override
  Widget build(BuildContext context) {
    var avatarUrl = userAvatarUrl();
    Widget userIcon = avatarUrl == null
        ? CustomIcons.badge(width: null)
        : CachedNetworkImage(
            imageUrl: avatarUrl,
          );

    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: _globalModel.isLogin
                  ? Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Positioned(
                            top: -20,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: userIcon,
                                onPressed: widget.onDrawerTap,
                                padding: EdgeInsets.all(0),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment(0.0, 0.8),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 4, right: 4, top: 1, bottom: 1),
                              decoration:
                                  BoxDecoration(color: Color(0xff90caf9)),
                              child: NoScaledText(
                                getUsername(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : IconButton(
                      icon: userIcon,
                      onPressed: widget.onDrawerTap,
                    ),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.pointer,
                onPressed: widget.onHomeTap,
              ),
              padding: EdgeInsets.only(left: 4),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.flower,
                onPressed: widget.onForumTap,
              ),
              padding: EdgeInsets.only(left: 4),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.game,
                onPressed: widget.onSwitchGameTap,
              ),
              padding: EdgeInsets.only(left: 4),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.setting,
                onPressed: widget.onSettingTap,
              ),
              padding: EdgeInsets.only(left: 4),
            ),
          ],
        ),
        height: 55,
      ),
    );
  }
}
