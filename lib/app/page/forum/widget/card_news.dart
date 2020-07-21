import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';

class CardNews extends StatelessWidget {
  final dynamic imgUrl;
  final String content;
  final Function onTap;

  const CardNews({Key key, this.imgUrl, this.content, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          margin: EdgeInsets.only(top: 10),
          constraints: BoxConstraints(minHeight: 80),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (imgUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: TinyUtils.thumbnailUrl(imgUrl ?? ''),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              SizedBox(width: 25),
              Expanded(
                child: Text(content,
                    softWrap: true, style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
