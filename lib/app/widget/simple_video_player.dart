import 'package:flutter/material.dart';

import 'package:liver3rd/app/widget/icons.dart';
import 'package:video_player_header/video_player_header.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String url;
  final Map header;
  final EdgeInsetsGeometry padding;

  const SimpleVideoPlayer(
      {Key key,
      @required this.url,
      this.header,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleVideoPlayerState();
  }
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  VideoPlayerController _videoController;
  Widget _videoControllerIcon = CustomIcons.play(color: Colors.white70);

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
      widget.url,
      headers: Map.from(widget.header ?? {}),
    )..initialize().then((_) {
        _videoController.setVolume(0.8);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.setVolume(0);
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        width: (MediaQuery.of(context).size.width - 40),
        height: (MediaQuery.of(context).size.width - 40) * 9 / 16,
        child: GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Stack(
              children: <Widget>[
                Center(
                  child: _videoController.value.initialized
                      ? Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: VideoProgressIndicator(
                                _videoController,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.blue[200],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          color: Colors.black45,
                        ),
                ),
                Center(
                  child: _videoControllerIcon,
                )
              ],
            ),
          ),
          onTap: () {
            if (!_videoController.value.initialized) {
              return;
            }
            if (_videoController.value.isPlaying) {
              setState(() {
                _videoControllerIcon = CustomIcons.play(color: Colors.white70);
              });
              _videoController.pause();
            } else {
              setState(() {
                _videoControllerIcon = Container();
              });
              _videoController.play();
            }
          },
        ),
      ),
    );
  }
}
