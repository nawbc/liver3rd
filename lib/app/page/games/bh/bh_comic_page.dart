import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/store/comics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/page/games/bh/widget/bh_comic_intro_card.dart';
import 'package:liver3rd/app/page/games/bh/widget/bh_comic_collection_card.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/turn_card_widget.dart';
import 'package:liver3rd/custom/easy_refresh/bezier_circle_header.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';

import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class BhComicPage extends StatefulWidget {
  final ScrollController nestController;

  const BhComicPage({Key key, this.nestController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BhComicPageState();
  }
}

class _BhComicPageState extends State<BhComicPage> {
  Comics _comics;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _comics = Provider.of<Comics>(context);
    if (_comics.bhComicsList.length == 0) {
      await _comics.fetchBhComicsList();
    }
  }

  Future<void> _freshState() async {
    _comics.bhComicsList = [];
    await _comics.fetchBhComicsList();
  }

  @override
  void dispose() {
    super.dispose();
    _comics?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int len = _comics.bhComicsList.length;
    return Scaffold(
      appBar: AppBar(
        title: CommonWidget.titleText('崩坏漫画'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: len <= 0
          ? CommonWidget.loading()
          : EasyRefresh.custom(
              header: BezierCircleHeader(
                backgroundColor: Colors.white,
                color: Colors.blue[200],
              ),
              onRefresh: () async {
                await _freshState();
                if (mounted) {
                  setState(() {});
                }
              },
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return SizedBox(height: ScreenUtil().setHeight(40));
                  }, childCount: 1),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Map c = _comics.bhComicsList[index];
                    return TurnCard(
                      front: BhComicIntroCard(
                        title: c['title'],
                        description: c['description'],
                        coverUrl: c['coverUrl'],
                      ),
                      back: BhComicCollectionCard(
                        coverUrl: c['coverUrl'],
                        chapterUrl: c['href'],
                      ),
                    );
                  }, childCount: len),
                ),
              ],
            ),
    );
  }
}

Handler bhComicPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return BhComicPage();
  },
);
