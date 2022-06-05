import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_player/component/custom_video.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // image나 video 모두 저장할 수 있다.
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(body: video != null ? renderVideo() : renderEmpty()),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        xFile: video!,
        onNewVideoPressed: onNewVideoPressed,
      ),
    );
  }

  Widget renderEmpty() {
    return Container(
      // BoxDecoration안에 color로 배경색을 바꾸는게 정석
      // BoxDecoration에 color값을 주면 Container의 Color는 쓰지 말아야함
      decoration: getBoxDecoration(),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(voidCallback: onNewVideoPressed),
          // SizedBox를 Padding대신 쓰는 경우는 한번더 감싸야하기 때문에 SizedBox를 안에 넣는것을 선호한다.
          const SizedBox(
            height: 30.0,
          ),
          const _AppName()
        ],
      ),
    );
  }

  void onNewVideoPressed() async {
    // gallery로만 가져오기
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    // iOS 이미지나 비디오 없으면 에뮬레이터로 드래그 엔 드롭해서 옮긴다.
    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback voidCallback;

  const _Logo({Key? key, required this.voidCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: voidCallback, child: Image.asset('asset/img/logo.png'));
  }
}

class _AppName extends StatelessWidget {
  const _AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Video',
          style: textStyle,
        ),
        Text('PLAYER', style: textStyle.copyWith(fontWeight: FontWeight.w700))
      ],
    );
  }
}

BoxDecoration getBoxDecoration() => const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          // begin
          Color(0xFF2A3A7C),
          Color(0xFF000118),
        ]));
