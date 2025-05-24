import 'package:drug/startup/startup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        fontFamily: 'dove_mayo',
      ),
      debugShowCheckedModeBanner: false,
      home: StartupScreen(),
    );
  }
}
