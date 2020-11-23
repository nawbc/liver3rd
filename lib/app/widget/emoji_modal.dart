import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';

class EmojiModal extends StatefulWidget {
  final TextEditingController textController;
  final Map emojis;
  final Function(String) onTap;

  const EmojiModal(
      {Key key,
      this.textController,
      @required this.emojis,
      @required this.onTap})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EmojiModalState();
  }
}

class _EmojiModalState extends State<EmojiModal> {
  TabController _tabController;
  List<Tab> _mainPageTabList = [];
  List _validEmojisList = [];
  Map _recentEmojis;

  initState() {
    super.initState();
    _recentEmojis = widget.emojis['recent'];

    if (_recentEmojis != null) {
      _mainPageTabList.add(
        Tab(
          child: Container(
            width: 33,
            height: 33,
            child: CachedNetworkImage(
              imageUrl: _recentEmojis['icon'],
            ),
          ),
        ),
      );
      _validEmojisList.add(_recentEmojis);
    }

    (widget.emojis['list'] as List)?.forEach(
      (val) {
        if (val['is_available']) {
          _mainPageTabList.add(
            Tab(
              child: Container(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: val['icon'],
                ),
              ),
            ),
          );
          _validEmojisList.add(val);
        }
      },
    );

    _tabController = TabController(
      length: _mainPageTabList.length,
      vsync: ScrollableState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 400),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Row(children: [
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 84,
            color: Colors.white,
            child: TabBar(
              tabs: _mainPageTabList,
              controller: _tabController,
              isScrollable: true,
              indicator: PointTabIndicator(
                position: PointTabIndicatorPosition.bottom,
                color: Colors.blue[200],
                insets: EdgeInsets.only(bottom: 5),
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 70,
            width: 50,
            color: Colors.white,
            child: IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.backspace,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ))
        ]),
        body: TabBarView(
          controller: _tabController,
          children: _mainPageTabList
              .asMap()
              .map(
                (index, val) {
                  return MapEntry(
                    index,
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.count(
                        crossAxisCount: 6,
                        childAspectRatio: 1.0,
                        children: (_validEmojisList[index]['list'] as List).map(
                          (ele) {
                            return GestureDetector(
                              onTap: () {
                                widget.onTap(ele['name']);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: CachedNetworkImage(
                                  imageUrl: ele['icon'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                },
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}
