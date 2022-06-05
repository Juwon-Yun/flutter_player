import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile xFile;

  const CustomVideoPlayer({Key? key, required this.xFile}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;

  // initState는 async화 할수 없다.
  @override
  void initState() {
    super.initState();

    initializeController();
  }

  initializeController() async {
    videoController = VideoPlayerController.file(File(widget.xFile.path));

    await videoController!.initialize();

    // initializeController를 기다리지 않기 때문에 build를 다시해라는 의미에서 setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return videoController != null
        ? VideoPlayer(videoController!)
        : CircularProgressIndicator();
  }
}
