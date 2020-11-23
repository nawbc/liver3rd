import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';

class Settings with ChangeNotifier {
  DateTime _timingTaskTime;
  DateTime get timgTaskTime => _timingTaskTime;

  setTiningTaskTime({bool isNotify = false}) async {
    String taskTime = await Share.getString(TIMING_TASK_TIME);
    _timingTaskTime = taskTime == null ? null : DateTime.parse(taskTime);
    if (isNotify) notifyListeners();
  }

  initSettings() async {
    setTiningTaskTime();
  }
}
