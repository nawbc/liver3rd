import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/api/bilibili/video_api.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/utils.dart';
import 'package:liver3rd/app/store/emojis.dart';
import 'package:liver3rd/app/store/global_model.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/cached_image_span.dart';
import 'package:liver3rd/app/widget/custom_modal_bottom_sheet.dart';
import 'package:liver3rd/app/widget/custom_textfield.dart';
import 'package:liver3rd/app/widget/emoji_modal.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/widget/menu_button.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/video_span.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:provider/provider.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class TextImage extends SpecialText {
  final int startIndex;
  final BuildContext context;

  TextImage(
    String startFlag,
    String endFlag,
    TextStyle textStyle,
    this.context, {
    this.startIndex,
  }) : super(startFlag, endFlag, textStyle);

  @override
  InlineSpan finishText() {
    var key = toString();
    var url = key.replaceAll(RegExp('$startFlag|$endFlag'), '');
    double width = MediaQuery.of(context).size.width;

    return CachedImageSpan(
      image: NetworkImage(url),
      containerWidth: width,
      actualText: key,
      imageWidth: width - 50,
      start: startIndex,
      fit: BoxFit.fill,
      margin: EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0),
      isCached: false,
    );
  }
}

class TextEmojis extends SpecialText {
  final Map emojis;
  final int startIndex;

  TextEmojis(String startFlag, String endFlag, TextStyle textStyle,
      {this.emojis, this.startIndex})
      : super(startFlag, endFlag, textStyle);

  @override
  InlineSpan finishText() {
    var key = toString();
    var name = key.replaceAll(RegExp('$startFlag|$endFlag'), '');

    return CachedImageSpan(
      actualText: key,
      imageWidth: 40,
      imageHeight: 40,
      imageUrl: emojis[name],
      start: startIndex,
    );
  }
}

class TextLink extends SpecialText {
  final int startIndex;
  final Function(String) onOpenLink;

  TextLink(String startFlag, String endFlag, TextStyle textStyle,
      {this.onOpenLink, this.startIndex})
      : super(startFlag, endFlag, textStyle);

  @override
  InlineSpan finishText() {
    var key = toString();
    var args =
        key.replaceAll(RegExp('$startFlag|$endFlag'), '').split(RegExp(r'@~@'));

    return SpecialTextSpan(
      actualText: key,
      start: startIndex,
      text: args[0],
      style: TextStyle(color: Colors.blue[200]),
    );
  }
}

class TextVideo extends SpecialText {
  final int startIndex;
  // TapGestureRecognizer _tapGestureRecognizer;

  TextVideo(String startFlag, String endFlag, TextStyle textStyle,
      {this.startIndex})
      : super(startFlag, endFlag, textStyle);

  @override
  InlineSpan finishText() {
    var key = toString();
    List<String> args =
        key.replaceAll(RegExp('$startFlag|$endFlag'), '').split(RegExp(r'@~@'));
    return VideoSpan(
      header: ReqUtils().customHeaders(
          referer: 'https://www.bilibili.com/video/av${args[0]}'),
      url: args[1],
    );
  }
}

class InnerSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  final Map emojis;
  final String emojiStartFlag;
  final String emojiEndFlag;
  final String imageStartFlag;
  final String imageEndFlag;
  final String linkStartFlag;
  final String linkEndFlag;
  final String videoStartFlag;
  final String videoEndFlag;
  final BuildContext context;

  InnerSpecialTextSpanBuilder(
    this.context, {
    @required this.emojis,
    this.emojiStartFlag,
    this.emojiEndFlag,
    this.imageStartFlag,
    this.imageEndFlag,
    this.linkStartFlag,
    this.linkEndFlag,
    this.videoStartFlag,
    this.videoEndFlag,
  });

  @override
  SpecialText createSpecialText(String flag,
      {TextStyle textStyle, onTap, int index}) {
    if (isStart(flag, imageStartFlag)) {
      return TextImage(imageStartFlag, imageEndFlag, TextStyle(), context,
          startIndex: index);
    }

    if (isStart(flag, emojiStartFlag)) {
      return TextEmojis(emojiStartFlag, emojiEndFlag, textStyle,
          emojis: emojis, startIndex: index);
    }

    if (isStart(flag, linkStartFlag)) {
      return TextLink(linkStartFlag, linkEndFlag, textStyle, startIndex: index,
          onOpenLink: (url) {
        TinyUtils.openUrl(url, error: () {
          Scaffold.of(context)
              .showSnackBar(CommonWidget.snack('链接打开失败', isError: true));
        });
      });
    }

    if (isStart(flag, videoStartFlag)) {
      return TextVideo(videoStartFlag, videoEndFlag, textStyle,
          startIndex: index);
    }

    return null;
  }
}

class PostEditorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostEditorPageState();
  }
}

class _PostEditorPageState extends State<PostEditorPage> {
  GlobalModel _globalModel;
  String htmlContent = "";
  FocusNode _focusNode = FocusNode();
  TextEditingController _uriController;
  TextEditingController _textEditingController;
  TextEditingController _uriTextController;
  TextEditingController _videoNumController;

  ForumApi _forumApi = ForumApi();
  final GlobalKey _textFieldKey = GlobalKey();
  final TextEditingController _titleTextController = TextEditingController();
  final String _emojiStartFlag = '∬';
  final String _emojiEndFlag = '∭';
  final String _imageStartFlag = '⋘';
  final String _imageEndFlag = '⋙';
  final String _linkStartFlag = '≦';
  final String _linkEndFlag = '≧';
  final String _videoStartFlag = '⋚';
  final String _videoEndFlag = '⋛';

  List result = [];
  List _sendPostable = [1, 14, 26];

  List _sendAbleForums = [];

  @override
  void initState() {
    super.initState();
    _globalModel = Provider.of<GlobalModel>(context, listen: false);
    _uriController = TextEditingController();
    _uriTextController = TextEditingController();
    _videoNumController = TextEditingController();
    _textEditingController = TextEditingController()
      ..addListener(() {
        print('=============================');
        print(_textEditingController.text);
      });
  }

  @override
  dispose() {
    super.dispose();
    _uriTextController?.dispose();
    _videoNumController?.dispose();
    _textEditingController?.dispose();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (_sendAbleForums.isEmpty) {
      Map data = await _forumApi.fetchAllGamesForum();
      List forumList = data['data']['list'];
      forumList.forEach((val) {
        int gameId = val['game_id'];

        if (gameId == 2 || gameId == 1) {
          List forums = val['forums'];
          forums.forEach((ele) {
            if (_sendPostable.contains(ele['id'])) {
              _sendAbleForums.add(ele);
            }
          });
        }
      });
      if (mounted) {
        setState(() {});
      }
    }
  }

  // _structuredCcontentGenerator(String data) {
  // switch (behavior) {
  //   case '':
  //     break;
  //   default:
  //     result.add({'insert': _textEditingController.text});
  // }
  // }

  List<Widget> _forumMenuList(double width) {
    return _sendAbleForums
        .map(
          (val) => _forumSelectItem(
            width: width,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CachedNetworkImage(
                    imageUrl: val['icon_pure'], width: 30, height: 30),
                SizedBox(width: 5),
                NoScaledText(
                  val['name'],
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          ),
        )
        .toList();
  }

  Future<void> _uploadImages(BuildContext context, List<Asset> images) async {
    images.forEach((val) async {
      ByteData byteData = await val.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      try {
        Map data = await _forumApi.uploadImageToOss(imageData, val.name);
        print(data);
        _insertImage(data['data']['url']);
      } catch (err) {
        FLog.error(
          className: "PostEditorPage",
          methodName: "_uploadImages",
          text: "$err",
        );
        Scaffold.of(context).showSnackBar(
            CommonWidget.snack('图片添加失败, 确认是片添加失败, 确认是否登录', isError: true));
      }
    });
  }

  Future<void> _loadAssets(BuildContext context) async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        materialOptions: imagePickerSetting,
      );

      await _uploadImages(context, resultList);
    } catch (err) {
      FLog.error(
        className: "PostEditorPage",
        methodName: "_loadAssets",
        text: "$err",
      );
      if (!err.toString().contains(RegExp('cancelled'))) {
        Scaffold.of(context)
            .showSnackBar(CommonWidget.snack('选取图片失败', isError: true));
      }
    }
  }

  Widget _forumSelectItem({double width, Widget content}) => Container(
        height: 51,
        width: width,
        child: Center(child: content),
      );

  Future<void> _insertVideo(BuildContext context) async {
    String videoNum = _videoNumController.text.trim();
    // String
    String prefix =
        RegExp(r'^(a|b)v', caseSensitive: false).stringMatch(videoNum);

    if (num != null) {
      Map videoData = await VideoApi()
          .fetchVideo(videoNum, useNumType: prefix.toLowerCase());
      String url = videoData['data']['data']['durl'][0]['url'];
      String aid = videoData['aid'];
      _textEditingController.text +=
          '$_videoStartFlag$aid@~@$url$_videoEndFlag';
      Navigator.pop(context);
    } else {
      Scaffold.of(context)
          .showSnackBar(CommonWidget.snack('请输入正确BV号', isError: true));
    }
  }

  void _insertLink(BuildContext context) {
    String uri = _uriController.text.trim();
    String uriText = _uriTextController.text.trim();
    bool isUri = RegExp(r'^((https|http)?:\/\/)[^\s]+').hasMatch(uri);
    if (isUri) {
      _textEditingController.text +=
          '$_linkStartFlag$uriText@~@$uri$_linkEndFlag';
    } else {
      Scaffold.of(context)
          .showSnackBar(CommonWidget.snack('请输入正确链接', isError: true));
    }
  }

  void _insertEmoji(String name) {
    _textEditingController.text += '$_emojiStartFlag$name$_emojiEndFlag';
  }

  void _insertImage(String url) {
    _textEditingController.text += '$_imageStartFlag$url$_imageEndFlag';
  }

  void _showAddLink(BuildContext context) {
    Dialogs.showConfirmDialog(
      context,
      title: '添加链接',
      onCannel: () {
        Navigator.pop(context);
      },
      onOk: () {
        _insertLink(context);
        Navigator.pop(context);
      },
      children: [
        CommonWidget.borderTextField(
          textController: _uriTextController,
          hintText: '链接文本',
          withBorder: true,
          height: 50,
        ),
        SizedBox(height: 15),
        CommonWidget.borderTextField(
          textController: _uriController,
          hintText: '地址URI',
          withBorder: true,
          height: 50,
        ),
      ],
    );
  }

  void _showAddVideo(BuildContext context) {
    Dialogs.showConfirmDialog(
      context,
      title: '哔哩哔哩AV 或 BV号',
      onCannel: () {
        Navigator.pop(context);
      },
      onOk: () {
        _insertVideo(context);
      },
      children: [
        CommonWidget.borderTextField(
          textController: _videoNumController,
          hintText: 'AV 或 BV号',
          withBorder: true,
          height: 50,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  void _releasePost(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    double validWidth = MediaQuery.of(context).size.width - 30;
    double forumSelectWidth = validWidth * 1 / 3 - 10;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CommonWidget.titleText('发帖'),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 134,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, right: 15, left: 15),
                        child: Container(
                            child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                width: forumSelectWidth,
                                height: 51,
                                child: MenuButton(
                                  itemsList: _sendAbleForums.isEmpty
                                      ? [
                                          _forumSelectItem(
                                            width: forumSelectWidth,
                                            content: NoScaledText(
                                              '板块',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ]
                                      : _forumMenuList(forumSelectWidth),
                                  height: 51,
                                  width: forumSelectWidth,
                                  onItemPressed: (index) {
                                    // _sendAbleForums[index];
                                  },
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: validWidth * 2 / 3,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, right: 15, left: 15),
                        child: CustomTextField(
                          controller: _titleTextController,
                          hintText: '输入标题',
                          withBorder: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  width: MediaQuery.of(context).size.width,
                  child: ExtendedTextField(
                    key: _textFieldKey,
                    specialTextSpanBuilder: InnerSpecialTextSpanBuilder(
                      context,
                      emojis: _globalModel.emojis['list_in_all'],
                      emojiStartFlag: _emojiStartFlag,
                      emojiEndFlag: _emojiEndFlag,
                      imageStartFlag: _imageStartFlag,
                      imageEndFlag: _imageEndFlag,
                      linkStartFlag: _linkStartFlag,
                      linkEndFlag: _linkEndFlag,
                      videoStartFlag: _videoStartFlag,
                      videoEndFlag: _videoEndFlag,
                    ),
                    controller: _textEditingController,
                    maxLines: null,
                    focusNode: _focusNode,
                    showCursor: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: '输入内容',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 53,
                padding: EdgeInsets.only(left: 10, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      offset: Offset(6.0, 6.0),
                      spreadRadius: -6,
                    )
                  ],
                ),
                child: Builder(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: CustomIcons.donut(),
                              onPressed: () {
                                showCustomModalBottomSheet(
                                  context: context,
                                  child: AnimatedPadding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    duration: const Duration(milliseconds: 100),
                                    child: EmojiModal(
                                      emojis: _globalModel.emojis,
                                      onTap: _insertEmoji,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: CustomIcons.picture(),
                              onPressed: () async {
                                await _loadAssets(context);
                              },
                            ),
                            IconButton(
                              icon: CustomIcons.film(),
                              onPressed: () {
                                _showAddVideo(context);
                              },
                            ),
                            IconButton(
                              icon: CustomIcons.magnet(),
                              onPressed: () {
                                _showAddLink(context);
                              },
                            ),
                            IconButton(
                                icon: CustomIcons.crown(), onPressed: () {}),
                          ],
                        ),
                        CommonWidget.button(
                          width: 65,
                          content: '发布',
                          onPressed: () {
                            _releasePost(context);
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Handler userPostEditorPageHandler = Handler(
  transactionType: TransactionType.fromBottom,
  pageBuilder: (BuildContext context, arg) {
    return PostEditorPage();
  },
);
