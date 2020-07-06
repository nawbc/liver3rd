import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:liver3rd/app/store/model/redemptionCode.dart';

class Redemption with ChangeNotifier {
  List _codeList = [];
  List get codeList => _codeList;
  set codeList(List val) {
    _codeList = [];
  }

  Future<void> fetchRedemptionCode({int limit}) async {
    BmobQuery<RedemptionCode> query = BmobQuery();
    query.setLimit(limit ?? 200);
    _codeList = await query.queryObjects().catchError((err) {
      FLog.error(
        className: "Redemption",
        methodName: "fetchRedemptionCode",
        text: "$err",
      );
    });
    notifyListeners();
  }
}
