import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/api/netease/netease_api.dart';
import 'package:liver3rd/app/api/netease/src_links.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liver3rd/custom/easy_refresh/easy_refresh.dart';

import 'package:liver3rd/custom/navigate/navigate.dart';

import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class MusicPage extends StatefulWidget {
  final String playListId;

  const MusicPage({Key key, this.playListId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MusicPageState();
  }
}

class _MusicPageState extends State<MusicPage> {
  Map _musicData = {};
  EasyRefreshController _controller = EasyRefreshController();

  NeteaseApi _neteaseApi = NeteaseApi();

  Future<void> _onRefresh() async {
    _musicData = {};
    Map tmp = await _neteaseApi.fetchPlayList(id: widget.playListId);

    if (mounted) {
      setState(() {
        _musicData = tmp;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_musicData.isEmpty) {
      await _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidget.titleText('音乐'),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: _musicData.isEmpty
          ? CommonWidget.loading()
          : EasyRefresh.custom(
              controller: _controller,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return SizedBox(height: ScreenUtil().setHeight(40));
                  }, childCount: 1),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      List playList = _musicData['playlist']['tracks'];
                      String heroTag = Uuid().v1();
                      String coverUrl = playList[index]['al']['picUrl'];
                      String id = playList[index]['id'].toString();
                      return ListTile(
                        onTap: () {
                          Navigate.navigate(
                            context,
                            'musicplayer',
                            arg: {
                              'coverUrl': coverUrl,
                              'tag': heroTag,
                              'playList': playList,
                              'index': index,
                            },
                          );
                        },
                        contentPadding: EdgeInsets.all(0),
                        leading: Padding(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                          child: Hero(
                            tag: heroTag,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: coverUrl,
                                width: ScreenUtil().setWidth(120),
                              ),
                            ),
                          ),
                        ),
                        subtitle: Text(playList[index]['ar'][0]['name']),
                        title: Text(
                          playList[index]['name'],
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(45),
                          ),
                        ),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          padding: EdgeInsets.all(0),
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                child: Text("分享"),
                                value: "share",
                                textStyle: TextStyle(
                                    color: Color(0xff242424),
                                    fontSize: ScreenUtil().setSp(45)),
                              ),
                            ];
                          },
                          onSelected: (String action) {
                            switch (action) {
                              case "share":
                                Share.share(shareSongUrl(id));
                                break;
                            }
                          },
                        ),
                      );
                    },
                    childCount: _musicData['playlist']['tracks'].length,
                  ),
                ),
              ],
            ),
    );
  }
}

Handler musicPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return MusicPage(
      playListId: arg['playListId'],
    );
  },
);
