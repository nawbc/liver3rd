import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/custom_modal_bottom_sheet.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class AccountEditorPage extends StatefulWidget {
  final String replyTarget;
  const AccountEditorPage({Key key, this.replyTarget}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountEditorPageState();
  }
}

class _AccountEditorPageState extends State<AccountEditorPage> {
  User _user;
  int _gender;
  Map _info;
  UserApi _userApi = UserApi();
  bool _locker = true;
  List _avatars = [];
  Map _avatarInfo;

  TextEditingController _introController;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    _info = _user.info['data']['user_info'];
    _avatarInfo = {'icon': _info['avatar_url'], 'id': _info['avatar']};
    _gender = _info['gender'];

    _introController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_locker) {
      Map data = await _userApi.fetchUserAvatars();
      List la = data['data']['list'];
      for (var i = 0; i < la.length; i++) {
        List lb = la[i]['list'];
        _avatars.addAll(lb);
      }
      setState(() {});
      _locker = false;
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
          title: CommonWidget.titleText('账户编辑'),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
        ),
        body: EasyRefresh.custom(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  child: Column(children: [
                    // SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        showCustomModalBottomSheet(
                          context: context,
                          child: Scaffold(
                            body: AnimatedPadding(
                              padding: MediaQuery.of(context).viewInsets,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: GridView.count(
                                  crossAxisCount: 4,
                                  childAspectRatio: 1.0,
                                  children: _avatars.map((ele) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _avatarInfo = ele;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: ele['icon'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(width: 2, color: Colors.grey),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: _avatarInfo['icon'],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '点击更换',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    CommonWidget.borderTextField(
                      height: 51,
                      enabled: false,
                      hintText: '昵称: ${_info['nickname']}',
                      keyboardType: TextInputType.phone,
                      withBorder: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          '性别:',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gender = 1;
                            });
                          },
                          child: CustomIcons.male(
                              width: 20,
                              color: _gender == 1 ? null : Colors.grey[400]),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gender = 2;
                            });
                          },
                          child: CustomIcons.female(
                              width: 20,
                              color: _gender == 2 ? null : Colors.grey[400]),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gender = 3;
                            });
                          },
                          child: CustomIcons.unknown(
                              width: 20,
                              color: _gender == 3 ? null : Colors.grey[400]),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    CommonWidget.borderTextField(
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 15, right: 10, bottom: 5),
                      maxLength: 48,
                      textController: _introController,
                      hintText: '${_info['introduce']}',
                      keyboardType: TextInputType.phone,
                      withBorder: true,
                      minLines: 10,
                    ),
                    SizedBox(height: 40),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      CommonWidget.button(
                        width: 80,
                        textStyle: TextStyle(fontSize: 16),
                        onPressed: () async {
                          _userApi
                              .editUserInfo(
                            avatarUrl: _avatarInfo['icon'],
                            avatar: '${_avatarInfo['id']}',
                            gender: _gender,
                            gids: '1',
                            introduce: _introController.text == ''
                                ? _info['introduce']
                                : _introController.text,
                          )
                              .then((data) async {
                            Scaffold.of(context).showSnackBar(
                              CommonWidget.snack(TextSnack['saveSuccess']),
                            );
                            await _user.getMyFullInfo() ;
                          }).catchError((err) {
                            FLog.error(text: err, className: 'AccountEditor');
                            Scaffold.of(context).showSnackBar(
                              CommonWidget.snack(TextSnack['saveError'],
                                  isError: true),
                            );
                          });
                        },
                        content: '保存',
                      )
                    ]),
                  ]),
                );
              }, childCount: 1),
            ),
          ],
        ),
      ),
    );
  }
}

Handler accountEditorPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return AccountEditorPage();
  },
);
