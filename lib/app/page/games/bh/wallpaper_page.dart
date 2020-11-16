import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/store/wallpapers.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class WallPaperPage extends StatefulWidget {
  final String coverUrl;
  final String tag;
  WallPaperPage({this.coverUrl, this.tag});

  @override
  State<StatefulWidget> createState() {
    return _WallPaperPageState();
  }
}

class _WallPaperPageState extends State<WallPaperPage> {
  Wallpapers _wallpapers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wallpapers = Provider.of<Wallpapers>(context);
    if (_wallpapers.bhWallpapers.isEmpty) {
      _wallpapers.fetchBhWallpapers();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _wallpapers?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _wallpapers.bhWallpapers.isEmpty
          ? CommonWidget.loading()
          : ListView.builder(
              itemCount: _wallpapers.bhWallpapers['data']['list'].length,
              itemBuilder: (BuildContext context, int index) {
                List wallpaperList = _wallpapers.bhWallpapers['data']['list'];
                List img = wallpaperList[index]['ext'][0]['value'];
                return Container(
                  constraints: BoxConstraints(
                    minHeight: ScreenUtil().setHeight(600),
                  ),
                  child: PopupMenuButton(
                    child: Image.network(img[0]['url']),
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          child: NoScaledText("保存"),
                          value: "download",
                          textStyle: TextStyle(
                              color: Color(0xff242424),
                              fontSize: ScreenUtil().setSp(45)),
                        ),
                        PopupMenuItem<String>(
                          child: NoScaledText("分享"),
                          value: "share",
                          textStyle: TextStyle(
                              color: Color(0xff242424),
                              fontSize: ScreenUtil().setSp(45)),
                        ),
                      ];
                    },
                    onSelected: (String action) async {
                      switch (action) {
                        case "download":
                          await TinyUtils.saveImgToLocal(img[0]['url'],
                              onSuccess: () {
                            Scaffold.of(context)
                                .showSnackBar(CommonWidget.snack('保存成功'));
                          }, onError: () {
                            Scaffold.of(context)
                                .showSnackBar(CommonWidget.snack('保存失败'));
                          });
                          break;
                        case "share":
                          Share.share(img[0]['url']);
                          break;
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

var wallPaperPageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return WallPaperPage();
  },
);
