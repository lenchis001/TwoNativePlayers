import 'package:flutter/material.dart';
import 'package:video_player_plusplayer/video_player.dart';

class PlayerPage extends StatefulWidget {
  final String manifestUrl;
  final Duration? pauseIn;
  final Function? pauseCallback;

  final Duration? continueIn;
  final Function? continuInCallback;

  final Duration? disposeIn;
  final Function? disposeCallback;

  const PlayerPage(
      {Key? key,
      required this.manifestUrl,
      this.pauseIn,
      this.pauseCallback,
      this.continueIn,
      this.continuInCallback,
      this.disposeIn,
      this.disposeCallback})
      : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.manifestUrl,
    );
    _controller.initialize().then((_) => setState(() {
          _controller.play();

          if (widget.pauseIn != null) {
            Future.delayed(widget.pauseIn!, () {
              return _controller.pause();
            }).then((value) {
              if (widget.pauseCallback != null) {
                widget.pauseCallback!();
              }

              if (widget.continueIn != null) {
                Future.delayed(widget.continueIn!, () {
                  _controller.play();
                  if(widget.continuInCallback != null) {
                    widget.continuInCallback!();
                  }
                });
              }
            });
          }

          if (widget.disposeIn != null) {
            Future.delayed(widget.disposeIn!, () {
              _controller.dispose().then((_) {
                if (widget.disposeCallback != null) {
                  widget.disposeCallback!();
                }
              });
            });
          }
        }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
