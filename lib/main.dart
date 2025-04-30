import 'package:drug/main_tab_controller.dart';
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
      home: MainTabController(),
    );
  }
}
