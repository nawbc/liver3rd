import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class SelfRichTextHtml extends StatefulWidget {
  final String content;

  SelfRichTextHtml({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelfRichTextHtmlState();
  }
}

class _SelfRichTextHtmlState extends State<SelfRichTextHtml> {
  Widget _customRender(node, children) {
    if (node is dom.Element) {
      switch (node.localName) {
        case "img":
          return GestureDetector(
            onTap: () {
              Navigate.navigate(
                context,
                'photoviewpage',
                arg: {
                  'images': node.attributes['src'],
                  'index': 0,
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Image.network(
                  TinyUtils.thumbnailUrl(node.attributes['src']),
                  loadingBuilder: (context, widget, event) {
                    if (event == null) {
                      return widget;
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 9 / 16,
                        color: Colors.grey[200],
                      );
                    }
                  },
                ),
              ),
            ),
          );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: widget.content,
      defaultTextStyle: TextStyle(
        fontSize: 14,
      ),
      backgroundColor: Colors.white,
      linkStyle: TextStyle(color: Colors.blue[200]),
      blockSpacing: 7,
      onLinkTap: (url) {
        var matchedPostId = RegExp('(?<=/article/)(\\d+)').stringMatch(url);
        if (matchedPostId != null) {
          Navigate.navigate(context, 'post', arg: {'postId': matchedPostId});
        }
      },
      onImageTap: (src) {
        Navigate.navigate(
          context,
          'photoviewpage',
          arg: {
            'images': [
              {'url': src}
            ],
            'index': 0,
          },
        );
      },
      useRichText: false,
      //关闭 useRichText set to false for this to work.
      customRender: _customRender,
    );
  }
}
