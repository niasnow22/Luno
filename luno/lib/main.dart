import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(Luno());
}

class Luno extends StatelessWidget{
  const Luno({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}