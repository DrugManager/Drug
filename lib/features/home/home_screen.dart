import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/features/home/widget/drug_list_widget.dart';
import 'package:drug/features/add_drug/add_drug_screen.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDrugScreen()),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: mainColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
