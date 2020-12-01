import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';

import 'package:liver3rd/custom/navigate/navigate.dart';

class YsSelectPage extends StatelessWidget {
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
                        Navigate.navigate(context, 'yscomic');
                      },
                      title: '漫画',
                      color: Colors.cyan,
                      subTitle: 'comic',
                      height: ScreenUtil().setHeight(160),
                    ),
                  ],
                ),
              );
            }, childCount: 1),
          )
        ],

        //  (context, index) {
        //   return Padding(
        //     padding: EdgeInsets.only(
        //         top: MediaQuery.of(context).padding.top + 10,
        //         left: 15,
        //         right: 15),
        //     child:
        //   );
        // },
      ),
    );
  }
}

Handler ysSelectPageHandler = Handler(
  pageBuilder: (BuildContext context, arg) {
    return YsSelectPage();
  },
);
