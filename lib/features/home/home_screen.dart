import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/features/home/widget/drug_list_widget.dart';
import 'package:drug/features/add_drug/add_drug_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Key _drugListKey = UniqueKey();

  void _refreshDrugList() {
    setState(() {
      _drugListKey = UniqueKey();
    });
  }

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
      body: DrugListWidget(key: _drugListKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDrugScreen()),
          );

          // 약 등록이 성공했을 때 목록 새로고침
          if (result == true) {
            _refreshDrugList();
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: mainColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
