import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:liver3rd/app/page/ads.dart';
import 'package:liver3rd/app/store/settings.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class TimingTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimingTaskState();
  }
}

class _TimingTaskState extends State<TimingTask> {
  DateTime _dateTime;
  bool _isChecked = false;
  Settings settings;
  // InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    settings = Provider.of<Settings>(context, listen: false);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {
      _dateTime = settings.timgTaskTime;
      _isChecked = _dateTime != null;
    });
  }

  Future<void> registerTask() async {
    String time = _dateTime.toString();
    Workmanager.registerOneOffTask(
      Uuid().v4(),
      WORKER_MISSION_NAME,
      tag: WORKER_MISSION_TAG,
      initialDelay:
          Duration(seconds: TinyUtils.nowToTomorrowDuration(time).inSeconds),
      inputData: {'registerTime': time},
    );

    await Share.setString(TIMING_TASK_TIME, time);
    await TinyUtils.showNotification(
      id: NOTIFICATION_TIMING_TASK,
      name: 'startTimingTask',
      title: '定时签到任务',
      subTitle: '还有${TinyUtils.nowToTomorrowDuration(time).inMinutes}分钟',
      payload: 'timingMission',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onVerticalDragDown: (details) {
            Workmanager.cancelByTag(WORKER_MISSION_TAG);
            setState(() {
              _isChecked = false;
            });
          },
          child: TimePickerSpinner(
            time: settings.timgTaskTime,
            is24HourMode: true,
            normalTextStyle: TextStyle(fontSize: 23, color: Colors.grey),
            itemHeight: 43,
            onTimeChange: (time) {
              setState(() {
                _dateTime = time;
              });
            },
          ),
        ),
        Container(
          width: 80,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () async {
                    // _interstitialAd = createInterstitialAd((event) async {
                    //   switch (event) {
                    //     case MobileAdEvent.leftApplication:
                    //       await registerTask();
                    //       if (mounted) {
                    //         setState(() {
                    //           _isChecked = true;
                    //         });
                    //       }
                    //       _interstitialAd?.dispose();
                    //       break;
                    //     case MobileAdEvent.loaded:
                    //       _interstitialAd.show(
                    //         anchorType: AnchorType.bottom,
                    //         anchorOffset: 0.0,
                    //         horizontalCenterOffset: 0.0,
                    //       );
                    //       break;
                    //     case MobileAdEvent.failedToLoad:
                    //       await registerTask();
                    //       if (mounted) {
                    //         setState(() {
                    //           _isChecked = true;
                    //         });
                    //       }
                    //       FLog.error(
                    //         className: 'TimingTask',
                    //         methodName: 'load',
                    //         text: 'fail to load ads',
                    //       );
                    //       break;
                    //     default:
                    //       break;
                    //   }
                    // });

                    if (_isChecked) {
                      await Share.setString(TIMING_TASK_TIME, null);
                      Workmanager.cancelByTag(WORKER_MISSION_TAG);
                      Scaffold.of(context)
                          .showSnackBar(CommonWidget.snack('定时任务已取消'));
                      if (mounted)
                        setState(() {
                          _isChecked = false;
                        });
                    } else {
                      if (mounted) {
                        setState(() {
                          _isChecked = true;
                        });
                      }
                      await registerTask();
                      // _interstitialAd..load();
                      // Scaffold.of(context).showSnackBar(CommonWidget.snack(
                      //     '广告加载中......',
                      //     duration: Duration(milliseconds: 2000)));
                    }
                    settings.setTiningTaskTime(isNotify: true);
                  },
                  child: CustomSwitchButton(
                    backgroundColor: Colors.blue[200],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.white,
                    checked: _isChecked,
                  ),
                );
              }),
              SizedBox(height: 3),
              NoScaledText(
                '定时签到',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ],
    );
  }
}
