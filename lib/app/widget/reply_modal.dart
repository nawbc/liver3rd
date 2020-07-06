import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';

final TextEditingController _txtEditorController = TextEditingController();

showBottomReply(
  context, {
  Function(String) onChange,
  Function(String) onSend,
  String hintText = '是时候发评论了...',
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: CommonWidget.borderTextField(
                textController: _txtEditorController,
                height: 50,
                hintText: hintText,
              ),
            ),
            IconButton(
              icon: CustomIcons.send(color: Colors.blue[200]),
              onPressed: () {
                Navigator.of(context).pop();
                if (onSend != null) onSend(_txtEditorController.text);
              },
            )
          ],
        ),
        padding: EdgeInsets.all(7),
      ),
    ),
  );
}
