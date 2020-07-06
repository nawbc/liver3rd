import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  final Function onDrawerTap;
  final Function onSwitchGameTap;
  final Function onSettingTap;
  final Function onShopTap;

  BottomBar({
    this.onDrawerTap,
    this.onSwitchGameTap,
    this.onSettingTap,
    this.onShopTap,
  })  : assert(onDrawerTap != null),
        assert(onSettingTap != null),
        assert(onSettingTap != null);

  @override
  State<StatefulWidget> createState() {
    return _BottomBarState();
  }
}

class _BottomBarState extends State<BottomBar> {
  User _user;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
  }

  dynamic userAvatarUrl() {
    return _user.isLogin ? _user.info['data']['user_info']['avatar_url'] : null;
  }

  @override
  Widget build(BuildContext context) {
    var avatarUrl = userAvatarUrl();
    Widget userIcon = avatarUrl == null
        ? CustomIcons.user
        : CachedNetworkImage(
            imageUrl: avatarUrl,
            width: ScreenUtil().setWidth(77),
          );

    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        child: Row(
          children: <Widget>[
            Padding(
              child: IconButton(
                icon: userIcon,
                onPressed: widget.onDrawerTap,
              ),
              padding: EdgeInsets.only(left: 20),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.game,
                onPressed: widget.onSwitchGameTap,
              ),
              padding: EdgeInsets.only(left: 10),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.shop,
                onPressed: widget.onShopTap,
              ),
              padding: EdgeInsets.only(left: 10),
            ),
            Padding(
              child: IconButton(
                icon: CustomIcons.setting,
                onPressed: widget.onSettingTap,
              ),
              padding: EdgeInsets.only(left: 10),
            ),
          ],
        ),
        height: 53,
      ),
    );
  }
}
