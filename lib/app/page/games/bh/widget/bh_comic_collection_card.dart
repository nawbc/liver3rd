import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/bh/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liver3rd/app/page/games/bh/widget/bh_comic_wrapper.dart';

import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class BhComicCollectionCard extends StatefulWidget {
  final String chapterUrl;
  final String coverUrl;

  BhComicCollectionCard({Key key, this.chapterUrl, this.coverUrl})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BhComicCollectionCardState();
  }
}

class _BhComicCollectionCardState extends State<BhComicCollectionCard> {
  List _collections = [];
  BhComicsApi comicsApi = BhComicsApi();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_collections.length == 0) {
      List c = await comicsApi
          .fetchComicsCollectionBH(widget.chapterUrl + '/get_chapter');
      if (mounted) {
        setState(() {
          _collections = c;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _collections = [];
  }

  @override
  Widget build(BuildContext context) {
    int len = _collections.length;

    return BhComicWrapper(
      coverUrl: widget.coverUrl,
      child: Container(
        padding: EdgeInsets.all(
          ScreenUtil().setWidth(25),
        ),
        child: len <= 0
            ? CommonWidget.loading()
            : ListView.builder(
                controller: _scrollController,
                itemCount: len,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      String comicUrl = widget.chapterUrl +
                          '/${_collections[index]['chapterid']}';
                      Navigate.navigate(context, 'bhcomiccontent',
                          arg: comicUrl);
                    },
                    trailing: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            '$comicsCollectionCoverUrl${_collections[index]['bookid']}/${_collections[index]['chapterid']}.jpg',
                        width: ScreenUtil().setWidth(120),
                      ),
                    ),
                    title: Text(
                      _collections[index]['title'],
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(45),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
