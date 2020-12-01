import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liver3rd/app/api/netease/netease_api.dart';
import 'package:liver3rd/app/api/utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/icons.dart';
import 'package:liver3rd/custom/lyrics/lyric_controller.dart';
import 'package:liver3rd/custom/lyrics/lyric_util.dart';
import 'package:liver3rd/custom/lyrics/lyric_widget.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';
import 'package:liver3rd/custom/navigate/navigate.dart';

class MusicPlayerPage extends StatefulWidget {
  final String coverUrl;
  final String tag;
  final List playList;
  final int index;

  MusicPlayerPage({this.coverUrl, this.tag, this.playList, this.index});

  @override
  State<StatefulWidget> createState() {
    return _MusicPlayerPageState();
  }
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool _isPause = true;
  bool _isSimpleMode = false;
  LyricController _lyricController;
  String _currentSong = '';
  String _currentLyric = '';
  String _currentTlyric = '';
  Duration _position = Duration(seconds: 0);
  Duration _duration = Duration(seconds: 0);
  List _playList = [];
  int _index = 0;
  NeteaseApi _neteaseApi = NeteaseApi();
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _lyricController = LyricController(vsync: ScrollableState());
    _playList = widget.playList;
    _index = widget.index;
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      _lyricController.progress = _position;
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPlayerError.listen((err) {
      _releaseAudio();
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      _releaseAudio();
      int currentIndex = _index + 1;
      _switch(currentIndex, currentIndex < _playList.length);
    });
  }

  // 释放掉audio
  void _releaseAudio() {
    _audioPlayer.release();
    _position = Duration(seconds: 0);
    _duration = Duration(seconds: 0);
    // initState 只执行一次要重新new个
    _lyricController = LyricController(vsync: ScrollableState());
  }

  @override
  void dispose() {
    super.dispose();
    _releaseAudio();
    _playList = [];
    _index = 0;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    String id = _playList[widget.index]['id'].toString();
    if (_currentSong.isEmpty || _currentLyric.isEmpty) {
      Map song = await _neteaseApi.fetchSong(id: id);
      Map lyric = await _neteaseApi.fetchLyric(id: id);
      if (mounted) {
        setState(() {
          _currentSong = _getlegalSongUrl(song);
          _currentLyric = _getlegalLyric(lyric);
          _currentTlyric = _getlegalTlyric(lyric);
        });
      }
    }
  }

  _switch(int num, bool condition) async {
    setState(() {
      _currentLyric = '';
      _currentTlyric = '';
    });
    if (condition) {
      _releaseAudio();
      String id = _playList[num]['id'].toString();
      Map song = await _neteaseApi.fetchSong(id: id);
      Map lyric = await _neteaseApi.fetchLyric(id: id);

      if (mounted) {
        setState(() {
          _currentSong = _getlegalSongUrl(song);
          _currentLyric = _getlegalLyric(lyric);
          _currentTlyric = _getlegalTlyric(lyric);
          _index = num;
          _audioPlayer.play(_currentSong);
          _isPause = false;
        });
      }
    }
  }

  String _getlegalSongUrl(Map data) {
    return data.isNotEmpty
        ? data['data'].length != 0
            ? data['data'][0]['url']
            : ''
        : '';
  }

  String _getlegalLyric(Map data) {
    return data['lrc']['lyric'] != null ? data['lrc']['lyric'] : '';
  }

  String _getlegalTlyric(Map data) {
    return data['tlyric']['lyric'] != null ? data['tlyric']['lyric'] : '';
  }

  Future<void> _handlePlay(BuildContext context) async {
    if (_isPause && _currentSong != '') {
      int result = await _audioPlayer.play(_currentSong);
      if (result != 1) {
        Scaffold.of(context).showSnackBar(CommonWidget.snack('播放错误'));
      }

      setState(() {
        _isPause = false;
      });
    } else {
      int result = await _audioPlayer.pause();
      if (result != 1) {
        Scaffold.of(context).showSnackBar(CommonWidget.snack('暂停失败'));
      } else {
        setState(() {
          _isPause = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSong != '') {
      _audioPlayer.setUrl(_currentSong);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // 4
          Expanded(
            flex: _isSimpleMode ? 7 : 4,
            child: Container(
              width: double.infinity,
              child: Hero(
                tag: widget.tag, //唯一标记，前后两个路由页Hero的tag必须相同
                child: CachedNetworkImage(
                  imageUrl: _playList[_index]['album']['picUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  NoScaledText(
                    _playList[_index]['name'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ScreenUtil().setSp(50),
                    ),
                  ),
                  SizedBox(height: 5),
                  NoScaledText(
                    _playList[_index]['album']['name'],
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: ScreenUtil().setSp(40),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_isSimpleMode)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                child: _currentLyric == ''
                    ? CommonWidget.loading()
                    : LyricWidget(
                        lyricMaxWidth: MediaQuery.of(context).size.width - 50,
                        currLyricStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: ScreenUtil().setSp(45)),
                        draggingLyricStyle: TextStyle(
                            color: Colors.blue[200],
                            fontSize: ScreenUtil().setSp(45)),
                        draggingRemarkLyricStyle: TextStyle(
                            color: Colors.blue[200],
                            fontSize: ScreenUtil().setSp(45)),
                        lyricStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(40),
                        ),
                        remarkStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: ScreenUtil().setSp(35),
                        ),
                        size: Size(double.infinity, double.infinity),
                        lyrics: _currentLyric == ''
                            ? []
                            : LyricUtil.formatLyric(_currentLyric,
                                onError: () {}),
                        remarkLyrics: _currentTlyric == ''
                            ? []
                            : LyricUtil.formatLyric(_currentTlyric,
                                onError: () {}),
                        controller: _lyricController,
                      ),
              ),
            ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Slider(
                            onChanged: (double value) {
                              setState(() {
                                _position = Duration(seconds: value.toInt());
                                _audioPlayer.seek(_position);
                              });
                            },
                            divisions: _duration.inSeconds == 0
                                ? 1
                                : _duration.inSeconds,
                            label:
                                '${Duration(seconds: _position.inSeconds).toString().substring(2, 7)}',
                            activeColor: Colors.blue[200],
                            inactiveColor: Colors.grey,
                            min: 0.0,
                            max: _duration.inSeconds.toDouble(),
                            value: _position.inSeconds.toDouble(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                NoScaledText(
                                    _position.toString().substring(2, 7)),
                                NoScaledText(
                                    _duration.toString().substring(2, 7))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(builder: (BuildContext context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 15, right: 15),
                                tooltip: '下载',
                                icon: CustomIcons.downlaod,
                                onPressed: () async {
                                  if (_currentSong != '') {
                                    Scaffold.of(context).showSnackBar(
                                        CommonWidget.snack(
                                            '${_playList[_index]['name']} 开始下载'));
                                    ReqUtils().download(
                                      _currentSong,
                                      '${_playList[_index]['ar'][0]['name']} - ${_playList[_index]['name']}.mp3',
                                      onSuccess: () {
                                        Scaffold.of(context).showSnackBar(
                                            CommonWidget.snack(
                                                '${_playList[_index]['name']}下载成功'));
                                      },
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20, left: 15, right: 15),
                                tooltip: '模式',
                                icon: CustomIcons.musicmode,
                                onPressed: () async {
                                  setState(() {
                                    _isSimpleMode = !_isSimpleMode;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: CustomIcons.pre,
                                  onPressed: () {
                                    int currentIndex = _index - 1;
                                    _switch(currentIndex, currentIndex >= 0);
                                  },
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),
                                InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000)),
                                  onTap: () {
                                    _handlePlay(context);
                                  },
                                  child: _isPause
                                      ? CustomIcons.play()
                                      : CustomIcons.pause(),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),
                                IconButton(
                                  icon: CustomIcons.next,
                                  onPressed: () {
                                    int currentIndex = _index + 1;
                                    _switch(currentIndex,
                                        currentIndex < _playList.length);
                                  },
                                )
                              ]),
                        ],
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

var musicPlayerPageHandler = Handler(
  transactionType: TransactionType.fadeIn,
  pageBuilder: (BuildContext context, arg) {
    return MusicPlayerPage(
      coverUrl: arg['coverUrl'],
      tag: arg['tag'],
      index: arg['index'],
      playList: arg['playList'],
    );
  },
);
