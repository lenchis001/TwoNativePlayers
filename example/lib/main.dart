import 'package:flutter/material.dart';
import 'package:video_player_videohole_example/player_page.dart';

const _kStreamToPlay =
    'https://cdn.bitmovin.com/content/assets/art-of-motion-dash-hls-progressive/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd';

void main() {
  runApp(MaterialApp(
    home: Scaffold(body: HomePage()),
  ));
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String status;
  bool isSecondPlayerAvailable;
  HomePageState()
      : status = 'Playback using the first player instance.',
        isSecondPlayerAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Status: $status'),
      SizedBox(
          height: 320,
          child: PlayerPage(
            manifestUrl: _kStreamToPlay,
            pauseIn: Duration(seconds: 10),
            pauseCallback: () {
              setState(() {
                status =
                    'First player paused. String playback using second player instance';
                isSecondPlayerAvailable = true;
              });
            },
            continueIn: Duration(seconds: 30),
            continuInCallback: () {
              setState(() {
                status = 'Continue playback using the first instance';
              });
            },
          )),
      if (isSecondPlayerAvailable)
        SizedBox(
            height: 320,
            child: PlayerPage(
              manifestUrl: _kStreamToPlay,
              disposeIn: Duration(seconds: 20),
              disposeCallback: () {
                setState(() {
                  status = 'Second player was disposed';
                });
              },
            ))
    ]);
  }
}
