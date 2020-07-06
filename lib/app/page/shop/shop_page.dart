import 'package:flutter/material.dart';
import 'package:liver3rd/app/page/shop/shop_account_page.dart';
import 'package:liver3rd/app/page/shop/shop_present_page.dart';
import 'package:liver3rd/app/widget/sync_scroll_tabbar.dart';

import 'package:liver3rd/custom/navigate/navigate.dart';

class ShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopPageState();
  }
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return SyncScrollTabBar(
      tabTitles: ['礼品兑换', '账号商店'],
      isScrollable: true,
      syncScrollableChildren: (controller) {
        return <Widget>[
          ShopPresentPage(
            nestController: controller,
          ),
          ShopAccountPage()
        ];
      },
    );
  }
}

var shopPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return ShopPage();
  },
);
