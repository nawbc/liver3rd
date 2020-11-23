import 'package:flutter/material.dart';

import 'package:liver3rd/app/store/redemption.dart';
import 'package:liver3rd/app/utils/app_text.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/app/widget/timeline_item.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_bounce_footer.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class RedemptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RedemptionPageState();
  }
}

class _RedemptionPageState extends State<RedemptionPage> {
  final int _increaseNum = 6;
  int _childCount = 6;
  Redemption _redemption;
  bool _isLoadEmpty = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _redemption = Provider.of<Redemption>(context);
    if (_redemption.codeList.length <= 0) {
      await _freshRedemptionCode();
    }
  }

  Future<void> _freshRedemptionCode() async {
    _redemption.codeList = [];
    await _redemption.fetchRedemptionCode();
    var list = _redemption.codeList;
    if (list.length > 0) {
      await Share.setString(
        REDEMPTION_UPDATE_TIME,
        list[list.length - 1]['createdAt'],
      );
    } else {
      setState(() {
        _isLoadEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int len = _redemption.codeList.length;
    if (len < _increaseNum) {
      _childCount = len;
    }
    return Scaffold(
      appBar: AppBar(
        title: CommonWidget.titleText('兑换码'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigate.navigate(context, 'pushredemption');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[200],
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: len <= 0
          ? (_isLoadEmpty
              ? EmptyWidget(
                  title: TextSnack['empty'],
                )
              : CommonWidget.loading())
          : Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: EasyRefresh.custom(
                header: BezierCircleHeader(backgroundColor: Colors.blue[200]),
                footer: BezierBounceFooter(backgroundColor: Colors.blue[200]),
                onRefresh: () async {
                  await _freshRedemptionCode();
                  await Future.delayed(
                    Duration(seconds: 2),
                    () {
                      if (mounted) {
                        setState(
                          () {
                            _childCount =
                                len < _increaseNum ? len : _increaseNum;
                          },
                        );
                      }
                    },
                  );
                },
                onLoad: () async {
                  await Future.delayed(
                    Duration(milliseconds: 800),
                    () {
                      if (mounted) {
                        setState(() {
                          int unloadCount = len - _childCount;
                          if (unloadCount < _increaseNum && unloadCount >= 0) {
                            _childCount += unloadCount;
                          } else if (unloadCount >= _childCount) {
                            _childCount += _increaseNum;
                          }
                        });
                      }
                    },
                  );
                },
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var val = _redemption.codeList.reversed.toList()[index];
                        return Timeline(
                          onTapAvatar: (heroTag) {
                            Navigate.navigate(
                              context,
                              'userprofile',
                              arg: {
                                'heroTag': heroTag,
                                'uid': val['userUid'],
                              },
                            );
                          },
                          username: val['username'],
                          code: val['code'],
                          expire: val['expire'],
                          uid: val['userUid'],
                          description: val['description'],
                          avatarUrl: val['avatarUrl'],
                          createAt: val['createdAt'] ?? val['updatedAt'],
                        );
                      },
                      childCount: _childCount,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Handler redemptionsPageHandler = Handler(
  transactionType: TransactionType.fromBottomRight,
  pageBuilder: (BuildContext context, arg) {
    return RedemptionPage();
  },
);
