import 'package:drug/startup/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

void main() {
  runApp(const DrugApp());
}

class DrugApp extends StatelessWidget {
  const DrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: mainColor, centerTitle: true),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: mainColor,
          selectedItemColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'dove_mayo'
      ),
      home: StartupScreen(),
    );
  }
}
