import 'package:flutter/material.dart';
import 'package:liver3rd/app/widget/empty_widget.dart';
import 'package:liver3rd/custom/easy_refresh/src/refresher.dart';

class MessagePage extends StatefulWidget {
  final ScrollController nestScrollController;

  const MessagePage({Key key, this.nestScrollController}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MessagePageState();
  }
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  bool _locker = true;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        widget.nestScrollController.jumpTo(_scrollController.offset);
      });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_locker) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: EasyRefresh.custom(scrollController: _scrollController, slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              height: MediaQuery.of(context).size.height - 180,
              child: EmptyWidget(
                type: 'ys',
                title: '施工中',
              ),
            );
          }, childCount: 1),
        )
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
