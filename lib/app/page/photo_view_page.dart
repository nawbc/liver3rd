import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class PhotoViewPage extends StatefulWidget {
  final List images;
  final int index;

  const PhotoViewPage({Key key, this.images, this.index = 0}) : super(key: key);

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  int currentIndex;
  PageController controller;
  String _bottomContent;
  List _savedList;

  String _getImgUrl(index) {
    return widget.images[index] is String
        ? widget.images[index]
        : widget.images[index]['url'];
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
    currentIndex = widget.index;
    _savedList = [];
    _bottomContent = '保存';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(PhotoViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      _getImgUrl(index),
                    ),
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) {
                  return CommonWidget.loading();
                },
                backgroundDecoration: BoxDecoration(color: Colors.white),
                pageController: controller,
                enableRotation: true,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                    _bottomContent = '保存';
                  });
                },
              ),
            ),
          ),
          Positioned(
            //图片index显示
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: NoScaledText("${currentIndex + 1}/${widget.images.length}",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
                color: Colors.blue[200],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Builder(builder: (context) {
            return Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 40,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CommonWidget.button(
                  width: 60,
                  height: 30,
                  onPressed: () async {
                    await TinyUtils.saveImgToLocal(_getImgUrl(currentIndex),
                        onLoading: (count, total) {
                      double f = count / total;
                      String percent = f.toStringAsFixed(2).substring(2);

                      if (mounted) {
                        setState(() {
                          _bottomContent = '$percent%';
                          if (f == 1) {
                            _bottomContent = '成功';
                          }
                        });
                      }
                    }, onError: () {
                      BotToast.showText(text: '保存失败');
                    });
                  },
                  child: NoScaledText(
                    _bottomContent,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

Handler photoViewPageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return PhotoViewPage(
      images: arg['images'],
      index: arg['index'],
    );
  },
);
