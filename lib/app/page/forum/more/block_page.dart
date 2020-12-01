import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/store/global_model.dart';

import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';

class BlockPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlockPageState();
  }
}

class _BlockPageState extends State<BlockPage>
    with AutomaticKeepAliveClientMixin {
  bool _locker;
  ForumApi _forumApi;
  ScrollController _scrollController;
  GlobalModel _globalModel;
  List _forums;

  @override
  void initState() {
    super.initState();
    _locker = true;
    _forums = [];
    _forumApi = ForumApi();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);

    if (_locker) {
      Map tmp = await _forumApi.fetchAllGamesForum();

      if (mounted) {
        setState(() {
          _forums = tmp['data']['list'];
        });
      }
      _locker = false;
    }
  }

  /// [src_type] 0 ForumTopicPage 1
  void _navigatorToAccordSrcType(BuildContext context, Map data) {
    int type = data['src_type'];
    int id = data['id'];
    Navigate.navigate(
      context,
      'topic',
      arg: {'forum_id': id, 'src_type': type},
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(
        scrollController: _scrollController,
        slivers: _forums.isEmpty
            ? [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 80,
                      child: CommonWidget.loading(),
                    );
                  }, childCount: 1),
                )
              ]
            : _forums
                .toList()
                .asMap()
                .map(
                  (index, val) {
                    List innerForums = val['forums'];
                    int id = val['game_id'];

                    return MapEntry(
                      index,
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: 5, left: 5, right: 5, bottom: 40),
                            child: Column(
                              children: <Widget>[
                                CommonWidget.tabTitle(
                                    '${_globalModel.gameMap['$id']['name']}'),
                                SizedBox(height: 20),
                                Wrap(
                                  spacing: 15,
                                  runSpacing: 15,
                                  children: innerForums.map((val) {
                                    return ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      child: Material(
                                        color: Colors.grey[200],
                                        child: Ink(
                                          child: InkWell(
                                            onTap: () {
                                              _navigatorToAccordSrcType(
                                                  context, val);
                                            },
                                            child: Container(
                                              width: 110,
                                              height: 140,
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  ClipOval(
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      color: Colors.white,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            val['icon_pure'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  NoScaledText(
                                                      '${val['name']}'),
                                                  NoScaledText(
                                                    '热度:${val['hot_score']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }, childCount: 1),
                      ),
                    );
                  },
                )
                .values
                .toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
