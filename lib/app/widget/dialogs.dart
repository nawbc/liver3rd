import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

// ignore: must_be_immutable
class ListDialog extends Dialog {
  final String title;
  final List<Widget> list;

  ListDialog({this.title, this.list});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Container(
        width: screenWidth,
        height: screenHeight,
        alignment: Alignment.center,
        child: Wrap(
          children: <Widget>[
            Center(
              child: Container(
                width: screenWidth - 50,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (title != null)
                        ListTile(
                          title: NoScaledText(
                            title,
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                      ...list
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dialogs {
  static showPureDialog(BuildContext context, String content, {color}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: NoScaledText(
            content,
            style: color ?? TextStyle(color: Colors.grey),
          ),
          titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
        );
      },
    );
  }

  static showConfirmDialog(BuildContext context,
      {String title,
      Color color,
      List<Widget> children,
      onOk,
      onCannel}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: NoScaledText(
            title,
            style: color ?? TextStyle(color: Colors.grey),
          ),
          children: <Widget>[
            ...?children,
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CommonWidget.button(
                    width: 50, content: '取消', onPressed: onCannel),
                SizedBox(width: 15),
                CommonWidget.button(width: 80, content: '确定', onPressed: onOk),
              ],
            )
          ],
        );
      },
    );
  }

  static showSelectDialog(BuildContext context,
      {List list,
      Function(String, int) onSelect,
      String title,
      String selected}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ListDialog(
          title: title,
          list: list
              .asMap()
              .map((index, child) {
                return MapEntry(
                  index,
                  OptionItem(
                    title: list[index],
                    border: Border.all(width: 2, color: Colors.grey[400]),
                    titleColor: Colors.grey,
                    subTitleColor: Colors.grey[400],
                    color: Colors.grey[200],
                    onPress: () async {
                      if (list[index] != selected) {
                        onSelect(list[index], index);
                      }
                      Navigator.of(context).pop();
                    },
                    shadow: null,
                    extend: list[index] == selected ? Icon(Icons.done) : null,
                  ),
                );
              })
              .values
              .toList(),
        );
      },
    );
  }
}
