import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:liver3rd/app/api/forum/src_links.dart';
import 'package:liver3rd/app/page/forum/widget/icon_block.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/utils/complish_missions.dart';
import 'package:liver3rd/app/widget/timing_task.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class MyInfoModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserModalState();
  }
}

class _UserModalState extends State<MyInfoModal> {
  GlobalModel _globalModel;
  Map _missions = {};
  Map _missionsState = {};
  bool _loading = true;
  UserApi _userApi = UserApi();

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);

    if (_missions.isEmpty || _missionsState.isEmpty) {
      await _refresh();
    }
  }

  dynamic findMissionId(int id, List target) {
    for (var item in target) {
      if (item['mission_id'] == id) {
        return item;
      }
    }
    return null;
  }

  // 默认刷新用户信息
  Future<void> _refresh() async {
    setState(() {
      _loading = true;
    });
    Map missionsState = await _userApi.fetchMyMissionsState();
    Map missions = await _userApi.fetchMyMissions();
    if (mounted) {
      setState(() {
        _missions = missions;
        _missionsState = missionsState;
        _loading = false;
      });
    }
  }

  List<Widget> _missionsList(List allMissions) {
    return allMissions.map((ele) {
      Map mapMissionState =
          findMissionId(ele['id'], _missionsState['data']['states']);
      int finished =
          mapMissionState == null ? 0 : mapMissionState['happened_times'];
      int threshold = ele['threshold'];

      return Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: Container(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  NoScaledText(
                    '${ele['name']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 3),
                  NoScaledText(
                    '+${ele['points']}米游币',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[200],
                    ),
                  ),
                ],
              ),
              finished == threshold
                  ? NoScaledText('已完成')
                  : Row(
                      children: <Widget>[
                        NoScaledText(
                          '$finished',
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                        NoScaledText(
                          '/${ele['threshold']}',
                          style: TextStyle(),
                        )
                      ],
                    ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    double screenWidth = MediaQuery.of(context).size.width;

    if (!Provider.of<GlobalModel>(context).isLogin) {
      content = CommonWidget.loading();
    } else {
      Map info = _globalModel.userInfo['data']['user_info'];
      bool isCompleteMissions = _missionsState.isNotEmpty
          ? _missionsState['data']['can_get_points'] == 0
          : false;
      content = EasyRefresh.custom(
        header: BezierCircleHeader(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        onRefresh: _refresh,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: info['avatar_url'],
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () {
                                  Navigate.navigate(context, 'accounteditor');
                                },
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth / 3,
                                        ),
                                        child: NoScaledText(
                                          info['nickname'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      TinyUtils.selectGender(info['gender'])
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth / 3,
                                    ),
                                    child: NoScaledText(
                                      info['introduce'],
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {
                              return CommonWidget.button(
                                width: 60,
                                content: isCompleteMissions ? '已完成' : '一键完成',
                                onPressed: isCompleteMissions
                                    ? null
                                    : () async {
                                        setState(() {
                                          _loading = true;
                                        });
                                        await complishMissions(
                                          false,
                                          onSuccess: () {
                                            BotToast.showText(text: '任务完成');
                                          },
                                          onError: (err) {
                                            Scaffold.of(context).showSnackBar(
                                              CommonWidget.snack(
                                                  '一键完成部分任务失败，刷新查看',
                                                  isError: true),
                                            );
                                          },
                                        );
                                        await _refresh();
                                      },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    // 个人信息
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            NoScaledText(info['achieve']['followed_cnt']),
                            NoScaledText('粉丝')
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              NoScaledText(info['achieve']['follow_cnt']),
                              NoScaledText('关注')
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              NoScaledText(info['achieve']['like_num']),
                              NoScaledText('获赞')
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              IconBlock(
                                text: '兑换中心',
                                icon: CustomIcons.shop(width: 33),
                                onTap: () {
                                  Navigate.navigate(context, 'shop');
                                },
                              ),
                              SizedBox(width: 15),
                              IconBlock(
                                text: '米游币',
                                icon: CustomIcons.coin(width: 22),
                                onTap: () {
                                  Navigate.navigate(context, 'webview', arg: {
                                    'title': '米游币',
                                    'url': myCenterUrl,
                                    'withAppBar': false,
                                  });
                                },
                              ),
                              SizedBox(width: 15),
                              // IconBlock(
                              //   text: '活动',
                              //   icon: CustomIcons.donut(width: 30),
                              //   onTap: () {
                              //     Navigate.navigate(context, 'webview', arg: {
                              //       'title': '记录',
                              //       'url': myCoinRecordUrl,
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //任务完成状态
                    Container(
                      height: 230,
                      child: _loading
                          ? CommonWidget.loading()
                          : Wrap(
                              children: <Widget>[
                                Container(
                                  height: 36,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          NoScaledText('米游币: '),
                                          NoScaledText(
                                            '${_missionsState['data']['total_points']}',
                                            style:
                                                TextStyle(color: Colors.orange),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          NoScaledText('今日: '),
                                          NoScaledText(
                                            '${_missionsState['data']['already_received_points']}',
                                            style:
                                                TextStyle(color: Colors.orange),
                                          ),
                                          NoScaledText(
                                            '/${_missionsState['data']['today_total_points']}',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ...?_missionsList(
                                  _missions['data']['missions'],
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 10),
                    // 设置签到
                    TimingTask(),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _globalModel.logout();
                        },
                        child: NoScaledText(
                          '退出登录',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      );
    }
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 15, left: 22, right: 22),
          child: content),
      backgroundColor: Colors.white,
    );
  }
}
