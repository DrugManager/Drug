//TODO - 약 등록 화면(테스트단계)

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/features/add_drug/add_drug_view_model.dart';

class AddDrugScreen extends StatefulWidget {
  const AddDrugScreen({super.key});

  @override
  State<AddDrugScreen> createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends State<AddDrugScreen> {
  final AddDrugViewModel _viewModel = AddDrugViewModel();
  final TextEditingController _drugNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _totalDoseController = TextEditingController();

  Future<void> _saveDrug() async {
    // 유효성 검사
    final validationError = _viewModel.validateDrugName(
      _drugNameController.text,
    );
    if (validationError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    // Drug 객체 생성
    final drug = _viewModel.createDrug(
      drugName: _drugNameController.text,
      time: _timeController.text,
      day: _dayController.text,
      totalDoseCountStr: _totalDoseController.text,
    );

    try {
      await _viewModel.addDrug(drug);
      Navigator.pop(context, true); // true를 반환해서 성공을 알림
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('약이 등록되었습니다')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
    }
  }

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
        leading: SizedBox(
          width: 100,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: mainColor, size: 20),
                const SizedBox(width: 4),
                Text('뒤로가기', style: TextStyle(color: mainColor, fontSize: 16)),
              ],
            ),
          ),
        ),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _drugNameController,
              decoration: const InputDecoration(
                labelText: '약 이름 *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: '시간 (예: 08:00)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dayController,
              decoration: const InputDecoration(
                labelText: '요일 (예: 월)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _totalDoseController,
              decoration: const InputDecoration(
                labelText: '총 복용 횟수',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveDrug,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                '약 등록',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _drugNameController.dispose();
    _timeController.dispose();
    _dayController.dispose();
    _totalDoseController.dispose();
    super.dispose();
  }
}
