import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:preload_page_view/preload_page_view.dart';

class YsContentPage extends StatefulWidget {
  final Map contents;
  YsContentPage({this.contents});

  @override
  State<StatefulWidget> createState() {
    return _YsContentPageState();
  }
}

class _YsContentPageState extends State<YsContentPage> {
  @override
  Widget build(BuildContext context) {
    List _pictures = widget.contents['ext'][0]['value'];

    return Scaffold(
      body: PreloadPageView.builder(
        preloadPagesCount: 3,
        itemCount: _pictures.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            placeholder: (ctx, str) => CommonWidget.loading(),
            imageUrl: _pictures[index]['url'],
            errorWidget: (ctx, str, obj) => CustomIcons.loadErrorPicture,
          );
        },
      ),
    );
  }
}

Handler ysComicContentPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return YsContentPage(contents: arg);
  },
);
