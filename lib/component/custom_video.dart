import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_player/screen/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile xFile;
  final VoidCallback onNewVideoPressed;

  const CustomVideoPlayer({Key? key, required this.xFile, required this.onNewVideoPressed}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  Duration currentPosition = const Duration();
  bool showControls = false;

  // initState는 async화 할수 없다.
  @override
  void initState() {
    super.initState();

    initializeController();
  }

  // video를 재선택하면 initState는 호출되지 않고 didUpdateWidget만 호출된다.
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget){
    super.didUpdateWidget(oldWidget);
    print('didUpdate');

    if(oldWidget.xFile.path != widget.xFile.path){
      // 여기서 controller를 다시 초기화 시켜준다.
      initializeController();
      // error 방지 currentPosition도 초기화.
      setState((){
        currentPosition = Duration();
        showControls = false;
      });
    }
  }

  initializeController() async {
    videoController = VideoPlayerController.file(File(widget.xFile.path));

    await videoController!.initialize();
    videoController!.play();
    // videoController가 값이 변경될떄마다 listener가 실행됨.
    videoController!.addListener(() {
      final currentPosition = videoController!.value.position;

      // 바뀔떄마다 currentPosition 업데이트
      setState(() {
        if(currentPosition == videoController!.value.duration){
          showControls = true;
        }
        this.currentPosition = currentPosition;
      });
    });

    // initializeController를 기다리지 않기 때문에 build를 다시해라는 의미에서 setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return videoController != null
        // AspectRatio 위젯으로 동영상의 width, height 만큼 설정
        ? Scaffold(
            body: Container(
              decoration: getBoxDecoration(),
              child: Center(
                child: AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,
                    child: GestureDetector(
                      onTap: (){
                        setState((){
                          showControls = !showControls;
                        });
                      },
                      child: Stack(children: [
                        VideoPlayer(videoController!),
                        if(showControls)
                        _Controls(
                          onPlayPressed: onPlayPressed,
                          onForwardPressed: onForwardPressed,
                          onReversPressed: onReversPressed,
                          isPlay: videoController!.value.isPlaying,
                        ),
                        if(showControls)
                        _NewVideo(onPressed: widget.onNewVideoPressed),
                        _SliderBottom(
                          currentPosition: currentPosition,
                          maxPosition: videoController!.value.duration,
                          valueChanged: onSlideChange,
                        )
                      ]),
                    )),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  void onPlayPressed() {
    // 이미 실행중이면 중지
    // 실행중이 아니면 실행
    if (videoController!.value.isPlaying) {
      videoController!.pause();
      // Icon을 토글하려 setState()
      setState(() {});
    } else {
      showControls = false;
      videoController!.play();
      setState(() {});
    }
  }

  void onReversPressed() {
    // 현재 재생중인 실행값
    final currentPosition = videoController!.value.position;

    Duration position = const Duration();
    // 실행중인 값이 3초 보다 크다면
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - const Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    // 전체 실행 값
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = const Duration();

    // maxPosition - 3초 보다 현재 값이 더 크다면 => 현재 포지션이 더 작은 경우
    if ((maxPosition - const Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onSlideChange(value) {
    videoController!.seekTo(Duration(seconds: value.toInt()));
    print('change $currentPosition');
    setState(() {
      currentPosition = Duration(seconds: value.toInt());
    });
  }
}

class _SliderBottom extends StatelessWidget {
  const _SliderBottom({
    Key? key,
    required this.currentPosition,
    required this.maxPosition,
    required this.valueChanged,
  }) : super(key: key);

  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> valueChanged;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(
              // padLeft(2, '0') => 최소 2글자로 할건데 없으면 0으로 채워라
              '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                max: maxPosition.inSeconds.toDouble(),
                min: 0,
                value: currentPosition.inSeconds.toDouble(),
                onChanged: valueChanged,
              ),
            ),
            Text(
              // padLeft(2, '0') => 최소 2글자로 할건데 없으면 0으로 채워라
              '${maxPosition.inMinutes}:${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;
  const _NewVideo({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.photo_camera_back),
        color: Colors.white,
        iconSize: 30.0,
      ),
    );
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
      height: MediaQuery.of(context).size.height,
      child: Row(
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
