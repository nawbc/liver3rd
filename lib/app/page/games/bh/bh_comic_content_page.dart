import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/bh/bh_comics_api.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:preload_page_view/preload_page_view.dart';

class BhComicContentPage extends StatefulWidget {
  final String chapterUrl;
  BhComicContentPage({this.chapterUrl});

  @override
  State<StatefulWidget> createState() {
    return _BhContentPageState();
  }
}

class _BhContentPageState extends State<BhComicContentPage> {
  List _pictureList = [];
  BhComicsApi _bhComicsApi = BhComicsApi();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_pictureList.isEmpty) {
      List list = await _bhComicsApi.fetchAllComicImgBH(widget.chapterUrl);
      if (mounted) {
        setState(() {
          _pictureList = list;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pictureList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pictureList.isEmpty
          ? CommonWidget.loading()
          : PreloadPageView.builder(
              preloadPagesCount: 3,
              itemCount: _pictureList.length,
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  placeholder: (ctx, str) => CommonWidget.loading(),
                  imageUrl: _pictureList[index],
                  errorWidget: (ctx, str, obj) => CustomIcons.loadErrorPicture,
                );
              },
            ),
    );
  }
}

Handler bhComicContentPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return BhComicContentPage(chapterUrl: arg);
  },
);
