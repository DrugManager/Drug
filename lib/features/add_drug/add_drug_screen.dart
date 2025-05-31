//TODO - 약 등록 화면
import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

class AddDrugScreen extends StatelessWidget {
  const AddDrugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('약 등록'),
        titleTextStyle: TextStyle(
          color: mainColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: mainColor, size: 20),
          label: Text('뒤로가기', style: TextStyle(color: mainColor, fontSize: 20)),
        ),
        leadingWidth: 130,
      ),
      body: Center(
        child: Text(
          '약 등록 화면',
          style: TextStyle(fontSize: 24, color: mainColor),
        ),
      ),
    );
  }
}
