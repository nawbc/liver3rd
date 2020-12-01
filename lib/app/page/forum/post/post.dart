import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/page/forum/widget/forum_page_frame.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostPageState();
  }
}

class _PostPageState extends State<PostPage> {
  List<Tab> _tabList = [];
  TabController _tabController;
  GlobalModel _globalModel;
  bool _locker;

  @override
  void initState() {
    super.initState();
    _locker = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _globalModel = Provider.of<GlobalModel>(context);

    if (_locker) {
      _locker = false;
      _tabList = _globalModel.gameList.map((val) {
        return Tab(
          child: NoScaledText(
            val['name'],
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        );
      }).toList();

      _tabController = TabController(
        length: _tabList.length,
        vsync: ScrollableState(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: TabBar(
          tabs: _tabList,
          controller: _tabController,
          indicatorPadding: EdgeInsets.all(0),
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorHeight: 30.0,
            indicatorColor: Colors.blue[200],
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _globalModel.gameList
            .asMap()
            .map(
              (index, val) {
                return MapEntry(
                  index,
                  ForumPageFrame(
                    typeId: val['id'],
                    index: index,
                  ),
                );
              },
            )
            .values
            .toList(),
      ),
    );
  }
}
