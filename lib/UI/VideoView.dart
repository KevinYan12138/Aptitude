import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatefulWidget {
  final String videoId;

  const VideoView({Key key, this.videoId}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  static String videoId = '';

  bool _isPlayerReady = false;

  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    videoId = widget.videoId;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
        topActions: [
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          deactivate();
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            player,
          ],
        ),
      ),
    );
  }
}
