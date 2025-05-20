import 'package:drug/startup/startup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DrugApp());
}

class DrugApp extends StatelessWidget {
  const DrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'dove_mayo'
      ),
      home: StartupScreen(),
    );
  }
}
