import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String inject;
  final String title;
  WebviewPage({this.url = '', this.inject = '', this.title = ''});

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController _webController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: WebView(
          debuggingEnabled: true,
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webController = webViewController;
          },
          onPageFinished: (String url) {
            _webController?.evaluateJavascript(widget.inject)?.then(
                  (result) {},
                );
          },
        ),
      ),
    );
  }
}

Handler webviewPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return WebviewPage(
        url: arg['url'], inject: arg['inject'], title: arg['title']);
  },
);
