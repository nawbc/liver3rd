import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/bh/src_links.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArmsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: WebView(
          debuggingEnabled: true,
          initialUrl: armsUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

Handler armsPageHandler = Handler(
  transactionType: TransactionType.fromRight,
  pageBuilder: (BuildContext context, arg) {
    return ArmsPage();
  },
);
