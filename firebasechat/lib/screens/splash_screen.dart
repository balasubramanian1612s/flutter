import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network('https://img.pngio.com/best-fire-emoji-illustrations-royalty-free-vector-graphics-clip-fire-emoji-no-background-612_612.jpg'),
      ),
      
    );
  }
}
