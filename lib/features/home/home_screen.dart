import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/features/home/widget/drug_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(today);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Column(
          children: [
            const Text('오늘은'),
            Text(formattedDate, style: const TextStyle(fontSize: 16)),
            SizedBox(height: 8),
          ],
        ),
      ),
      body: drugList(),
    );
  }
}
