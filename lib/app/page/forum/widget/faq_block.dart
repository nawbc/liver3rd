import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FaqBlock extends StatelessWidget {
  final Function onTap;
  final String question;
  final String answer;
  final String name;
  final int answerCount;
  final String avatarUrl;

  const FaqBlock(
      {Key key,
      this.onTap,
      this.question,
      this.answer,
      this.name,
      this.answerCount,
      this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Colors.orange),
                child: Center(
                  child: Text(
                    '问',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(question, softWrap: true),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Colors.blue),
                child: Center(
                  child: Text(
                    '答',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(answer, softWrap: true),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                      width: 25,
                      height: 25,
                      child: CachedNetworkImage(imageUrl: avatarUrl),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(name)
                ],
              ),
              Text('全部$answerCount个回答')
            ],
          ),
        ]),
      ),
    );
  }
}
