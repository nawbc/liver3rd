import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/page/forum/search/search_topic_fragment.dart';
import 'package:liver3rd/app/page/forum/search/search_users_fragment.dart';
import 'package:liver3rd/app/page/forum/widget/common_posts_page.dart';
import 'package:liver3rd/app/widget/common_widget.dart';

class SearchResultFragment extends StatefulWidget {
  final String keyword;
  final int gids;
  final int initialIndex;

  const SearchResultFragment({
    Key key,
    this.keyword,
    this.gids,
    this.initialIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchResultFragmentState();
  }
}

class _SearchResultFragmentState extends State<SearchResultFragment> {
  List<Tab> _tabs;
  TabController _controller;
  ForumApi _forumApi = ForumApi();

  @override
  void initState() {
    super.initState();
    _tabs = [
      Tab(child: CommonWidget.tabTitle('帖子', fontSize: 16)),
      Tab(child: CommonWidget.tabTitle('话题', fontSize: 16)),
      Tab(child: CommonWidget.tabTitle('用户', fontSize: 16)),
    ];
    _controller = TabController(
      length: _tabs.length,
      vsync: ScrollableState(),
      initialIndex: widget.initialIndex ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: TabBar(
          tabs: _tabs,
          controller: _controller,
          indicatorPadding: EdgeInsets.all(0),
          indicator: PointTabIndicator(
            position: PointTabIndicatorPosition.bottom,
            color: Colors.blue[200],
            insets: EdgeInsets.only(bottom: 6),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            body: CommonPostsPage(
              fetchData: (Map tmpData) async {
                return _forumApi.searchResult(
                  1,
                  gids: widget.gids,
                  keyword: widget.keyword,
                  lastId: tmpData.isNotEmpty ? tmpData['data']['last_id'] : "0",
                );
              },
            ),
          ),
          SearchTopicsFragment(gids: widget.gids, keyword: widget.keyword),
          SearchUsersFragment(gids: widget.gids, keyword: widget.keyword),
        ],
      ),
    );
  }
}
