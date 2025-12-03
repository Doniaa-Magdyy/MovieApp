import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _text = "";
  final String _fullText = "Movie App";
  int _index = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 180), (timer) {
      if (_index < _fullText.length) {
        setState(() {
          _text += _fullText[_index];
          _index++;
        });
      } else {
        timer.cancel();
      }
    });

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie,
              size: 90,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              _text,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 32,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
