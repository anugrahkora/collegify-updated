
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String file;

  const VideoApp({Key key, @required this.file}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.file(new File(widget.file))
  //     ..addListener(() {
  //       print('controller listener: $_controller');
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {});
  //     })
  //     ..initialize().then((_) {
  //       print('initialized listener: $_controller');
  //       setState(() {});
  //     }).catchError((error) {
  //       print('Unexpected error1: $error');
  //     });
  //   print('controller is set');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text(widget.file),
      )

          //  _controller.value.isInitialized
          //     ? AspectRatio(
          //         aspectRatio: _controller.value.aspectRatio,
          //         child: VideoPlayer(
          //             VideoPlayerController.file(new File(widget.file))),
          //       )
          //     : Container(
          //         color: Colors.amber,
          //       ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() {
          //   _controller.value.isPlaying
          //       ? _controller.pause()
          //       : _controller.play();
          // });
        },
        child: Icon(
          Icons.pause,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
