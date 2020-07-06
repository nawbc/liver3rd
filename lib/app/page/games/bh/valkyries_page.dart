import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/store/valkyries.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';

import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

import 'widget/valkyrie_card.dart';

class ValkyriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ValkyriesPageState();
  }
}

class _ValkyriesPageState extends State<ValkyriesPage> {
  TabController _controller;
  List<Valkyrie> _valksyries;
  List<Tab> _valkyriesTabList;
  int _count = -1;

  List<Tab> _genValkyriesList() {
    return _valksyries
        .map(
          (valk) => Tab(
            icon: ClipOval(
                child: CachedNetworkImage(
              imageUrl: valk.avatarUrl,
              width: ScreenUtil().setWidth(95),
              height: ScreenUtil().setWidth(95),
              fit: BoxFit.cover,
            )),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _valksyries = Provider.of<Valkyries>(context, listen: false).valks;
    _valkyriesTabList = _genValkyriesList();
    _controller = TabController(
      length: _valkyriesTabList.length,
      vsync: ScrollableState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _count = -1;
    return Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: CommonWidget.titleText('女武神'),
                elevation: 0,
                leading: CustomIcons.back(context),
                bottom: TabBar(
                  tabs: _valkyriesTabList,
                  controller: _controller,
                  // 取消下划线
                  indicator: const BoxDecoration(),
                  isScrollable: true,
                ),
              ),
              body: TabBarView(
                controller: _controller,
                children: _valkyriesTabList.map((Tab tab) {
                  _count++;
                  return ValkyrieCard(
                    coverUrl: _valksyries[_count].coverUrl,
                    valkyrieName: _valksyries[_count].valkyrieName,
                    armorName: _valksyries[_count].armorName,
                    combatMode: _valksyries[_count].combatMode,
                    intro: _valksyries[_count].intro,
                    avatarUrl: _valksyries[_count].avatarUrl,
                    backgroundImgUrl: _valksyries[_count].backgroundImgUrl,
                    birthday: _valksyries[_count].birthday,
                    skills: _valksyries[_count].skills,
                    backgroundColor: _valksyries[_count].backgroundColor,
                  );
                }).toList(),
              ),
            ))
      ],
    );
  }
}

Handler valkyriesPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return ValkyriesPage();
  },
);
