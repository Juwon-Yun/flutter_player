import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // BoxDecoration안에 color로 배경색을 바꾸는게 정석
      // BoxDecoration에 color값을 주면 Container의 Color는 쓰지 말아야함
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // begin
                Color(0xFF2A3A7C),
                Color(0xFF000118),
              ]
          )
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('asset/img/logo.png'),
          Row(
            children: [const Text('Video'), const Text('PLAYER')],
          )
        ],
      ),
    ));
  }
}
