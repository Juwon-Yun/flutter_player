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
        // AspectRatio 위젯으로 동영상의 width, height 만큼 설정
        ? Scaffold(
            body: Center(
              child: AspectRatio(
                  aspectRatio: videoController!.value.aspectRatio,
                  child: Stack(children: [
                    VideoPlayer(videoController!),
                    _Controls(
                      onPlayPressed: onPlayPressed,
                      onForwardPressed: onForwardPressed,
                      onReversPressed: onReversPressed,
                      isPlay: videoController!.value.isPlaying,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.photo_camera_back),
                        color: Colors.white,
                        iconSize: 30.0,
                      ),
                    )
                  ])),
            ),
          )
        : CircularProgressIndicator();
  }

  void onPlayPressed() {
    // 이미 실행중이면 중지
    // 실행중이 아니면 실행
    if (videoController!.value.isPlaying) {
      videoController!.pause();
      // Icon을 토글하려 setState()
      setState(() {});
    } else {
      videoController!.play();
      setState(() {});
    }
  }

  void onReversPressed() {
    // 현재 재생중인 실행값
    final currentPosition = videoController!.value.duration;

    Duration position = Duration();
    // 실행중인 값이 3초 보다 크다면
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    // 전체 실행 값
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.duration;

    Duration position = Duration();

    // maxPosition - 3초 보다 현재 값이 더 크다면 => 현재 포지션이 더 작은 경우
    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversPressed;
  final VoidCallback onForwardPressed;
  final bool isPlay;
  const _Controls({
    Key? key,
    required this.onPlayPressed,
    required this.onReversPressed,
    required this.onForwardPressed,
    required this.isPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
              onPressed: onReversPressed, iconData: Icons.rotate_left),
          renderIconButton(
              onPressed: onPlayPressed,
              iconData: isPlay ? Icons.stop : Icons.play_arrow),
          renderIconButton(
              onPressed: onForwardPressed, iconData: Icons.rotate_right),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(iconData),
      color: Colors.white,
      iconSize: 30.0,
    );
  }
}
