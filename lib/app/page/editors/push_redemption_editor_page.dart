import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/store/model/redemptionCode.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/store/redemption.dart';
import 'package:liver3rd/app/widget/icons.dart';

import 'package:provider/provider.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class PushCodeEditorPage extends StatefulWidget {
  final String targetType;
  const PushCodeEditorPage({Key key, this.targetType}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PushCodeEditorPageState();
  }
}

class _PushCodeEditorPageState extends State<PushCodeEditorPage> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  DateTime _selectedValue = DateTime.now();
  GlobalModel _globalModel;
  Redemption _redemption;

  @override
  initState() {
    super.initState();
    _redemption = Provider.of<Redemption>(context, listen: false);
  }

  Future<bool> _isExistCode(List<dynamic> data, String code) async {
    if (data.length > 0) {
      for (var item in data) {
        if (item['code'] == code) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);
  }

  Future<void> _sendCode(BuildContext context) async {
    String code = _codeController.text.trim().toUpperCase();
    if (code != '' && _contentController.text != '') {
      await _redemption.fetchRedemptionCode();

      if (await _isExistCode(_redemption.codeList, code)) {
        Scaffold.of(context)
            .showSnackBar(CommonWidget.snack('发布失败 兑换码已存在', isError: true));
        return;
      }

      if (_globalModel.isLogin) {
        var user = _globalModel.userInfo['data']['user_info'];
        RedemptionCode redemptionCode = RedemptionCode();
        redemptionCode.code = code;
        redemptionCode.userUid = user['uid'];
        redemptionCode.avatarUrl = user['avatar_url'];
        redemptionCode.username = user['nickname'];
        redemptionCode.description = _contentController.text;
        redemptionCode.expire = _selectedValue.toString();
        redemptionCode.save().then((BmobSaved saved) async {
          Scaffold.of(context).showSnackBar(CommonWidget.snack('发布成功'));
        }).catchError((err) {
          FLog.error(
            className: "PushRedemptionEditorPage",
            methodName: "_sendCode",
            text: "$err",
          );
          Scaffold.of(context)
              .showSnackBar(CommonWidget.snack('发布失败', isError: true));
        });
      } else {
        Navigate.navigate(context, 'login');
      }
    } else {
      Scaffold.of(context)
          .showSnackBar(CommonWidget.snack('请输入内容', isError: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CommonWidget.titleText('发布兑换码'),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              heroTag: 'pushcode',
              onPressed: () {
                _sendCode(context);
              },
              child: CustomIcons.send(),
              backgroundColor: Colors.blue[200],
            );
          },
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(40),
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 2, color: Colors.grey[400]),
                ),
                child: TextField(
                  controller: _codeController,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    color: Colors.grey[600],
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: '兑换号',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(50),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  maxLines: 7,
                  minLines: 6,
                  controller: _contentController,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    color: Colors.grey[600],
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, top: 10),
                    hintText: '內容',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(50),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      children: <Widget>[
                        NoScaledText(
                          '过期日期',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        NoScaledText(
                          '${_selectedValue.year}/${_selectedValue.month}/${_selectedValue.day}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                            color: Colors.amber,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30)),
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.blue[200],
                    selectedTextColor: Colors.white,
                    onDateChange: (date) {
                      setState(() {
                        _selectedValue = date;
                      });
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(60)),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: NoScaledText(
                      '请不要随意发布无关兑换码',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Handler pushRedemptionEditorPageHandler = Handler(
  transactionType: TransactionType.fromBottomRight,
  pageBuilder: (BuildContext context, arg) {
    return PushCodeEditorPage();
  },
);
