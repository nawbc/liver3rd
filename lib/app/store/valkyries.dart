import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/bh/valkyries_api.dart';

class Valkyrie {
  String coverUrl;
  String valkyrieName; //符华
  String armorName; //云墨丹心
  String combatMode;
  String intro;
  String avatarUrl;
  String backgroundImgUrl;
  String birthday;
  List<Map<String, String>> skills;
  int total;
  Color backgroundColor;

  Valkyrie({
    this.coverUrl,
    this.valkyrieName,
    this.armorName,
    this.combatMode,
    this.intro,
    this.avatarUrl,
    this.backgroundImgUrl,
    this.birthday,
    this.total,
    this.backgroundColor,
    this.skills,
  });
}

class Valkyries with ChangeNotifier {
  List<Valkyrie> _valks = [];
  List<Valkyrie> get valks => _valks;

  Future<void> fetchValkyries() async {
    Map data = await ValkyriesApi().init();
    List valksList = data['data']['list'];
    for (var ele in valksList) {
      List ext = ele['ext'];

      _valks.add(
        Valkyrie(
            valkyrieName: ele['title'],
            coverUrl: ext[3]['value'][0]['url'],
            armorName: ext[0]['value'],
            combatMode: ext[1]['value'],
            intro: ext[2]['value'],
            avatarUrl: ext[4]['value'][0]['url'],
            backgroundImgUrl: ext[5]['value'][0]['url'],
            birthday: ext[43]['value'],
            total: data['total'],
            skills: [
              {
                'name': ext[6]['value'],
                'description': ext[7]['value'],
                'icon': ext[8]['value'][0]['url']
              },
              {
                'name': ext[12]['value'],
                'description': ext[13]['value'],
                'icon': ext[14]['value'][0]['url']
              },
              {
                'name': ext[18]['value'],
                'description': ext[19]['value'],
                'icon': ext[20]['value'][0]['url']
              },
              {
                'name': ext[24]['value'],
                'description': ext[25]['value'],
                'icon': ext[26]['value'][0]['url']
              }
            ],
            backgroundColor: setValkyrieBackground(ele['contentId'])),
      );
    }
    // notifyListeners();
  }

  Color setValkyrieBackground(String id) {
    switch (id) {
      case "6339":
        return Color(0xff779646);
      case "3472":
        return Color(0xff274ead);
      case "3471":
        return Color(0xffe23a6e);
      case "3473":
        return Color(0xff4633b1);
      case "3474":
        return Color(0xff252d90);
      case "3468":
        return Color(0xfff1f1f1);
      case "3469":
        return Color(0xff52b7ff);
      case "3470":
        return Color(0xff8ea52c);
      case "6126":
        return Color(0xff2e2945);
      case "3464":
        return Color(0xff453fa0);
      case "3465":
        return Color(0xff645a5c);
      case "3466":
        return Color(0xffa00e0e);
      case "3467":
        return Color(0xff959ec7);
      case "3498":
        return Color(0xff5a3526);
      case "3461":
        return Color(0xff0e0828);
      case "3462":
        return Color(0xff2f1051);
      case "3463":
        return Color(0xffa59cc1);
      case "3455":
        return Color(0xff905c9a);
      case "3457":
        return Color(0xff312d52);
      case "3458":
        return Color(0xffc27c9b);
      case "3459":
        return Color(0xff816996);
      case "3460":
        return Color(0xff110d1e);
      case "3497":
        return Color(0xff1d16af);
      case "3452":
        return Color(0xffb54671);
      case "3453":
        return Color(0xff232a8f);
      case "3454":
        return Color(0xff801d38);
      case "3691":
        return Color(0xff462d2e);
      case "3438":
        return Color(0xff671e1d);
      case "3439":
        return Color(0xffca2723);
      case "3440":
        return Color(0xff741615);
      case "3441":
        return Color(0xff2b232e);
      case "3442":
        return Color(0xff005ab6);
      case "3443":
        return Color(0xff7c0309);
      case "1226":
        return Color(0xff06042e);
      case "3431":
        return Color(0xfff9c60c);
      case "3432":
        return Color(0xff3a1756);
      case "3433":
        return Color(0xffdea871);
      case "3434":
        return Color(0xff5d3c35);
      case "3435":
        return Color(0xff151021);
      case "3496":
        return Color(0xffdedcdb);
      case "3436":
        return Color(0xff359aeb);
      case "1222":
        return Color(0xffbf2259);
      case "1223":
        return Color(0xff191919);
      case "1224":
        return Color(0xff820107);
      case "1225":
        return Color(0xffa538a4);
      case "3495":
        return Color(0xff383cb4);
      case "1217":
        return Color(0xffd2551a);
      case "1218":
        return Color(0xffdf7336);
      case "1219":
        return Color(0xff726180);
      case "1220":
        return Color(0xff92625a);
      case "1221":
        return Color(0xfffaa711);
      case "3494":
        return Color(0xffdb4924);
      default:
        return Colors.cyan[400];
    }
  }
}
