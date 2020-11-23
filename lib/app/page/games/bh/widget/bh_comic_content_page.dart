import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/bh/bh_comics_api.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class BhComicContentPage extends StatefulWidget {
  final String chapterUrl;

  BhComicContentPage({this.chapterUrl});

  @override
  State<StatefulWidget> createState() {
    return _BHContentPageState();
  }
}

class _BHContentPageState extends State<BhComicContentPage> {
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
          : PageView(
              scrollDirection: Axis.horizontal,
              children: _pictureList.map(
                (img) {
                  return CachedNetworkImage(
                    placeholder: (ctx, str) => CommonWidget.loading(),
                    imageUrl: img,
                    errorWidget: (ctx, str, obj) =>
                        CustomIcons.loadErrorPicture,
                  );
                },
              ).toList(),
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
