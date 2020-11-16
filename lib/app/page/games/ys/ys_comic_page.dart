import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liver3rd/app/api/ys/ys_comics_api.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class YsComicPage extends StatefulWidget {
  final ScrollController nestController;

  const YsComicPage({Key key, this.nestController}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _YsComicPageState();
  }
}

class _YsComicPageState extends State<YsComicPage> {
  YsComicsApi _ysComicsApi = YsComicsApi();
  List _comics = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_comics.isEmpty) {
      Map tmp = await _ysComicsApi.fetchComicsListYS();
      if (mounted) {
        setState(() {
          _comics = tmp['data']['list'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidget.titleText('原神漫画'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _comics.isEmpty
          ? CommonWidget.loading()
          : Builder(
              builder: (context) {
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 15,
                    bottom: 50,
                  ),
                  crossAxisCount: 4,
                  itemCount: _comics.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigate.navigate(
                          context,
                          'yscomiccontent',
                          arg: _comics[index],
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints.expand(),
                              child: CachedNetworkImage(
                                imageUrl: _comics[index]['ext'][1]['value'][0]
                                    ['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: ScreenUtil().setHeight(40),
                              child: Container(
                                color: Colors.black54,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 2,
                                    bottom: 2,
                                    left: 5,
                                    right: ScreenUtil().setWidth(40),
                                  ),
                                  child: Center(
                                    child: NoScaledText(
                                      _comics[index]['title'],
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(50),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(2, index.isEven ? 2 : 1.3),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              },
            ),
    );
  }
}

Handler ysComicPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return YsComicPage();
  },
);
