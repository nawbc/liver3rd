import 'package:flutter/material.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/utils/complish_missions.dart';
import 'package:liver3rd/app/widget/timing_task.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:provider/provider.dart';

class MyInfoModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserModalState();
  }
}

class _UserModalState extends State<MyInfoModal> {
  User _user;
  Map _missions = {};
  Map _missionsState = {};
  UserApi _userApi = UserApi();

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
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
    Map missionsState = await _userApi.fetchMyMissionsState();
    Map missions = await _userApi.fetchMyMissions();
    if (mounted) {
      setState(() {
        _missions = missions;
        _missionsState = missionsState;
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

    if (!Provider.of<User>(context).isLogin) {
      content = CommonWidget.loading();
    } else {
      Map info = _user.info['data']['user_info'];
      bool isCompleteMissions = _missionsState.isNotEmpty
          ? _missionsState['data']['can_get_points'] == 0
          : false;
      content = EasyRefresh.custom(
        header: BezierCircleHeader(
          backgroundColor: Colors.white,
          color: Colors.blue[200],
        ),
        onRefresh: () async {
          await _refresh();
        },
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
                                onTap: () {},
                              ),
                              SizedBox(width: ScreenUtil().setWidth(40)),
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
                                      SizedBox(
                                          width: ScreenUtil().setWidth(20)),
                                      TinyUtils.selectGender(info['gender'])
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(15)),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth / 3,
                                    ),
                                    child: NoScaledText(
                                      info['introduce'],
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40)),
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
                                        TinyUtils.checkPurchase(
                                          context,
                                          () async {
                                            await complishMissions(
                                              onSuccess: () {
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  CommonWidget.snack('签到完成'),
                                                );
                                                _refresh();
                                              },
                                              onError: (err) {
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  CommonWidget.snack(
                                                      '一键完成部分任务失败，刷新查看',
                                                      isError: true),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(35)),
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
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    //任务完成状态
                    Container(
                      height: 230,
                      child: (_missions.isEmpty && _missionsState.isEmpty)
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
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    // 设置签到
                    TimingTask(),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(100),
                      child: RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _user.logout();
                        },
                        child: NoScaledText(
                          '退出登录',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
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
