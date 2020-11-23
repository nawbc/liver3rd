import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide WebView;
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'common_widget.dart';
import 'icons.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String inject;
  final String title;
  final Map headers;
  WebviewPage({this.url = '', this.inject = '', this.title = '', this.headers});

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController _webController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidget.titleText(widget.title),
        centerTitle: true,
        leading: CustomIcons.back(context),
        elevation: 0,
      ),
      body: WebView(
        // initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webController = webViewController;
          print(widget.headers);
          if (widget.headers != null) {
            _webController.loadUrl(widget.url, headers: widget.headers);
          } else {
            _webController.loadUrl(
              widget.url,
            );
          }
        },
        onPageFinished: (String url) async {
          if (widget.inject != null) {
            await _webController?.evaluateJavascript(widget.inject);
          }
        },
      ),
    );
  }
}

Handler webviewPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return WebviewPage(
        url: arg['url'],
        inject: arg['inject'],
        title: arg['title'],
        headers: arg['headers']);
  },
);

class InAppWebViewPage extends StatefulWidget {
  final String url;
  final String inject;
  final String title;
  final Map headers;
  InAppWebViewPage(
      {this.url = '', this.inject = '', this.title = '', this.headers});

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController _webController;

  @override
  Widget build(BuildContext context) {
    print(widget.headers);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidget.titleText(widget.title),
        centerTitle: true,
        leading: CustomIcons.back(context),
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: InAppWebView(
            initialUrl: widget.url,
            initialHeaders: widget.headers,
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              debuggingEnabled: TinyUtils.isDev,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              _webController = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              // setState(() {
              //   // this.url = url;
              // });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              // setState(() {
              //   // this.url = url;
              // });
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              // setState(() {
              //   this.progress = progress / 100;
              // });
            },
          ),
        )
      ]),
    );
  }
}

Handler inAppWebViewPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return InAppWebViewPage(
        url: arg['url'],
        inject: arg['inject'],
        title: arg['title'],
        headers: arg['headers']);
  },
);
