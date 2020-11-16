import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/store/user.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/custom_chip.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/row_icon_button.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class PostBlock extends StatefulWidget {
  final Function(bool) onTapUpvote;
  final String postContent;
  final String title;
  final List imgList;
  final Map stat;
  final List topics;
  final bool isUpvoted;
  final Function(int) onImageTap;
  final Function onContentTap;
  final Widget headBlock;

  const PostBlock({
    Key key,
    @required this.onTapUpvote,
    @required this.postContent,
    @required this.title,
    @required this.imgList,
    @required this.stat,
    this.topics,
    @required this.isUpvoted,
    @required this.onImageTap,
    @required this.onContentTap,
    @required this.headBlock,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostBlockState();
  }
}

class _PostBlockState extends State<PostBlock>
    with AutomaticKeepAliveClientMixin {
  bool _isUpvote;
  int _likedNum;
  User _user;
  initState() {
    super.initState();
    _isUpvote = widget.isUpvoted;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<User>(context);
    _likedNum = widget.stat['like_num'] is String
        ? int.parse(widget.stat['like_num'])
        : widget.stat['like_num'];
  }

  @override
  void dispose() {
    super.dispose();
    _isUpvote = _isUpvote;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int imgLength = widget.imgList.length;
    int displayImgLength =
        widget.imgList.length < 3 ? widget.imgList.length : 3;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          widget.headBlock,
          Container(
            padding: EdgeInsets.only(left: 13, right: 13),
            width: screenWidth,
            child: GestureDetector(
              onTap: widget.onContentTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    child: NoScaledText(
                      widget.title.trim(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: screenWidth,
                    child: NoScaledText(
                      widget.postContent,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 13),
          if (imgLength > 1)
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.imgList
                    .getRange(0, displayImgLength)
                    .toList()
                    .asMap()
                    .map(
                      (index, val) {
                        return MapEntry(
                          index,
                          Padding(
                            padding: EdgeInsets.only(
                                right: displayImgLength - 1 != index ? 10 : 0),
                            child: Container(
                              width: (screenWidth - 70) / 3,
                              height: (screenWidth - 70) / 3,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: GestureDetector(
                                  onTap: () {
                                    widget.onImageTap(index);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        TinyUtils.thumbnailUrl(val['url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    .values
                    .toList(),
              ),
            ),
          if (imgLength == 1)
            Builder(
              builder: (context) {
                var img = widget.imgList[0];
                var imgWidth = MediaQuery.of(context).size.width - 46;
                var imgRate = img['height'] / img['width'];
                var heightRate = (imgWidth / imgRate) >
                        (MediaQuery.of(context).size.height / 2)
                    ? 16 / 9
                    : imgRate;
                return Container(
                  padding: EdgeInsets.only(left: 13, right: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: imgWidth,
                      height: imgWidth / heightRate,
                      child: GestureDetector(
                        onTap: () {
                          widget.onImageTap(0);
                        },
                        child: CachedNetworkImage(
                          imageUrl: TinyUtils.thumbnailUrl(img['url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: 16),
          Container(
            height: 40,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (widget.topics != null && widget.topics.isNotEmpty) ...[
                  CustomChip(
                    color: Colors.blue[200],
                    height: 25,
                    maxWidth: 60,
                    onPressed: () {
                      Navigate.navigate(context, 'topicinfo',
                          arg: {'forumId': widget.topics[0]['id']});
                    },
                    content: NoScaledText(
                      widget.topics[0]['name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 25,
                  ),
                ],
                if ((widget.topics != null && widget.topics.isEmpty) ||
                    widget.topics == null)
                  Container(),
                Container(
                  child: Row(
                    children: <Widget>[
                      RowIconButton(
                        icon: CustomIcons.eye(),
                        text: '${widget.stat['view_num']}',
                      ),
                      RowIconButton(
                        icon: CustomIcons.comment(),
                        text: '${widget.stat['reply_num']}',
                      ),
                      RowIconButton(
                        icon: _isUpvote
                            ? CustomIcons.like(color: Colors.red)
                            : CustomIcons.like(),
                        text: '$_likedNum',
                        onPressed: () {
                          if (_user.isLogin) {
                            if (widget.onTapUpvote != null)
                              widget.onTapUpvote(_isUpvote);
                            setState(() {
                              _isUpvote ? _likedNum-- : _likedNum++;
                              _isUpvote = !_isUpvote;
                            });
                          } else {
                            Navigate.navigate(context, 'login');
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
