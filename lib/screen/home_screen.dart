import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: Container(
        // BoxDecoration안에 color로 배경색을 바꾸는게 정석
        // BoxDecoration에 color값을 주면 Container의 Color는 쓰지 말아야함
        decoration: getBoxDecoration(),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _Logo(),
            // SizedBox를 Padding대신 쓰는 경우는 한번더 감싸야하기 때문에 SizedBox를 안에 넣는것을 선호한다.
            SizedBox(
              height: 30.0,
            ),
            _AppName()
          ],
        ),
      )),
    );
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

class _Logo extends StatelessWidget {
  const _Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('asset/img/logo.png');
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
