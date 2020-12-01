import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/bh/src_links.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class BhSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 15,
                    right: 15),
                child: Column(
                  children: <Widget>[
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(context, 'bhcomic');
                      },
                      title: '漫画',
                      color: Colors.brown,
                      subTitle: 'comic',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(context, 'musicpage',
                            arg: {'playListId': '4888083122'});
                      },
                      title: '音乐',
                      color: Colors.cyan,
                      subTitle: 'music for honkai impact',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(context, 'officalmv',
                            arg: {'type': 1});
                      },
                      title: 'MV',
                      color: Colors.indigo,
                      subTitle: 'honkai impact offical mv',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(context, 'valkyries');
                      },
                      title: '女武神',
                      color: Colors.amber,
                      subTitle: 'valkyrie collections',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(
                          context,
                          'webview',
                          arg: {'title': '武器', 'url': armsUrl},
                        );
                      },
                      title: '武器',
                      color: Color(0xff242424),
                      subTitle: 'weapon introduce',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        // Navigate.navigate(context, 'raiders');
                        Navigate.navigate(context, 'webview', arg: {
                          'inject': injectRaidersScript,
                          'title': '攻略',
                          'url': raidersUrl
                        });
                      },
                      title: '攻略',
                      color: Colors.blue[300],
                      subTitle: 'raiders',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(context, 'webview',
                            arg: {'title': '圣痕', 'url': stigmaUrl});
                      },
                      title: '圣痕',
                      color: Colors.purple[800],
                      subTitle: 'stigma system',
                      height: 70,
                    ),
                    OptionItem(
                      onPress: () {
                        Navigate.navigate(context, 'wallpaper');
                      },
                      title: '官方壁纸',
                      color: Colors.green[300],
                      subTitle: 'wall paper',
                      height: 70,
                    ),
                  ],
                ),
              );
            }, childCount: 1),
          )
        ],

        //  (context, index) {

        // },
      ),
    );
  }
}

Handler bhSelectPageHandler = Handler(
  pageBuilder: (BuildContext context, arg) {
    return BhSelectPage();
  },
);
