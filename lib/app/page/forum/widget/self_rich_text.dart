import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:liver3rd/app/api/utils.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/api/bilibili/video_api.dart';
import 'package:liver3rd/app/widget/parse_emoji_text.dart';
import 'package:liver3rd/app/widget/simple_video_player.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class SelfRichText extends StatefulWidget {
  final List<Map> content;
  final Map emojis;
  final TextSpan head;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double lineSpacing;
  final List imagesList;
  final Function onContentTap;

  SelfRichText({
    Key key,
    @required this.content,
    @required this.emojis,
    this.head,
    this.padding = const EdgeInsets.all(0),
    this.backgroundColor = Colors.white,
    this.lineSpacing,
    this.imagesList = const [],
    this.onContentTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelfRichTextState();
  }
}

class _SelfRichTextState extends State<SelfRichText> {
  List<Widget> _contentList;
  Color _defaultLinkColor = Colors.blue[200];

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();

    try {
      if (_contentList == null) {
        List<Widget> richText =
            await _richTextGenterator(context, widget.content);
        if (mounted) {
          setState(() {
            _contentList = richText;
          });
        }
      }
    } catch (err) {
      print(err);
    }
  }

  // 如果是null返回默认
  Future<List<Widget>> _richTextGenterator(
      BuildContext context, List<Map> data) async {
    List<Widget> richtext = [];
    List<TextSpan> textSpanBlock = [];
    int imageCount = 0;

    void addImage(String image, num rate, int index) {
      double width = MediaQuery.of(context).size.width - 44;
      richtext.add(
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              width: width,
              height: width / rate,
              color: Colors.grey,
              child: GestureDetector(
                onTap: () {
                  if (widget.imagesList.isNotEmpty &&
                      imageCount <= widget.imagesList.length) {
                    Navigate.navigate(
                      context,
                      'photoviewpage',
                      arg: {
                        'images': widget.imagesList,
                        'index': index,
                      },
                    );
                  }
                },
                child: Image.network(
                  TinyUtils.thumbnailUrl(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (widget.head != null) textSpanBlock.add(widget.head);

    for (var i = 0; i < data.length; i++) {
      Map current = data[i];
      Map currentAttr = current['attributes'];
      var currentInsert = current['insert'];

      String describe = current['describe'];
      List imgs = current['imgs'];

      if (describe is String) {
        richtext.add(
          Text.rich(
            TextSpan(
              children: [
                parseEmojiText(
                  emojis: widget.emojis,
                  str: describe,
                  lineSpacing: widget.lineSpacing,
                  onPressed: widget.onContentTap,
                )
              ],
            ),
            textScaleFactor: 1,
          ),
        );
      }
      //图片帖子
      if (imgs is List) {
        for (var i = 0; i < imgs.length; i++) {
          addImage(imgs[i], 16 / 9, i);
        }
      }

      if (currentInsert is String) {
        var endbreakLine = RegExp(r'((\n)+)$').stringMatch(currentInsert);

        if (currentAttr != null) {
          String link = currentAttr['link'];
          textSpanBlock.add(
            parseEmojiText(
              emojis: widget.emojis,
              str: currentInsert,
              lineSpacing: widget.lineSpacing,
              fontSize: _matchFontSize(currentAttr['header']),
              color: link != null
                  ? _defaultLinkColor
                  : _matchColor(currentAttr['color']),
              fontWeight:
                  currentAttr['header'] != null ? FontWeight.bold : null,
              fontStyle:
                  currentAttr['italic'] != null ? FontStyle.italic : null,
              onPressed: link != null
                  ? () {
                      String matchedPostId =
                          RegExp('(?<=/article/)(\\d+)').stringMatch(link);
                      if (matchedPostId != null) {
                        Navigate.navigate(context, 'post',
                            arg: {'postId': matchedPostId});
                      } else {
                        TinyUtils.openUrl(link);
                      }
                    }
                  : widget.onContentTap,
            ),
          );
        } else {
          textSpanBlock.add(
            parseEmojiText(
              emojis: widget.emojis,
              str: currentInsert,
              lineSpacing: widget.lineSpacing,
              onPressed: widget.onContentTap,
            ),
          );
        }
        // 末行匹配到\n 生成一个textrich, 使用insert=\n的style 子级继承
        if (endbreakLine != null || i == data.length - 1) {
          if (currentAttr != null) {
            richtext.add(
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text.rich(
                  TextSpan(
                      children: textSpanBlock,
                      style: TextStyle(
                        fontWeight: _matchFontWeight(
                            currentAttr['header'] ?? currentAttr['bold']),
                        fontSize: _matchFontSize(currentAttr['header']),
                        fontStyle: _matchFontStyle(currentAttr['italic']),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onContentTap),
                  textAlign: _matchAlign(currentAttr),
                  textScaleFactor: 1,
                ),
              ),
            );
          } else {
            richtext.add(
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text.rich(
                  TextSpan(
                    children: textSpanBlock,
                  ),
                  textScaleFactor: 1,
                ),
              ),
            );
          }
          // 不能用clear 会导致原来List 加到textspan children 中
          textSpanBlock = [];
        }
      } else if (currentInsert is Map) {
        var image = currentInsert['image'];
        var video = currentInsert['video'];
        // 存取当前照片数
        int tmpCount = imageCount;
        if (image != null) {
          addImage(
              image, currentAttr['width'] / currentAttr['height'], tmpCount);
          if (imageCount < widget.imagesList.length) imageCount++;
        }
        if (video != null) {
          Map videoData = await VideoApi().fetchVideo(video);

          richtext.add(
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: SimpleVideoPlayer(
                url: videoData['data']['data']['durl'][0]['url'],
                header: ReqUtils().customHeaders(
                  referer:
                      'https://www.bilibili.com/video/av${videoData['aid']}',
                ),
              ),
            ),
          );
        }
      }
    }

    return richtext;
  }

  TextAlign _matchAlign(Map attr) {
    if (attr != null && attr['align'] != null) {
      switch (attr['align']) {
        case 'center':
          return TextAlign.center;
        case 'left':
          return TextAlign.left;
        case 'right':
          return TextAlign.right;
        default:
          return TextAlign.center;
      }
    } else {
      return TextAlign.left;
    }
  }

  Color _matchColor(String color) {
    switch (color) {
      case 'amber':
        return Colors.amber;
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'green':
        return Colors.green;
      case 'grey':
        return Colors.grey;
      case 'indigo':
        return Colors.indigo;
      case 'lime':
        return Colors.lime;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      default:
        if (color == null) {
          return Color(0xff242424);
        } else if (color.startsWith('#')) {
          return Color(int.parse(color.replaceFirst('#', '0xff')));
        } else {
          return Color(0xff242424);
        }
    }
  }

  double _matchFontSize(int header) {
    switch (header) {
      case 1:
        return 22;
      case 2:
        return 20;
      case 3:
        return 18;
      case 5:
        return 16;
      case 6:
        return 14;
      default:
        return null;
    }
  }

  FontWeight _matchFontWeight(dynamic size) {
    return size == null ? FontWeight.normal : FontWeight.bold;
  }

  FontStyle _matchFontStyle(dynamic style) {
    return style == null ? FontStyle.normal : FontStyle.italic;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 16, color: Colors.grey),
      child: Container(
        padding: widget.padding,
        color: widget.backgroundColor,
        child: InkWell(
          onTap: widget.onContentTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                _contentList == null ? <Widget>[Container()] : _contentList,
          ),
        ),
      ),
    );
  }
}
