import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/features/home/widget/drug_list_viewmodel.dart';

Widget drugList() {
  final viewModel = DrugListViewModel();

  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    itemCount: viewModel.drugs.length,
    separatorBuilder:
        (context, index) => const Divider(
          thickness: 1,
          height: 24,
          color: Color.fromARGB(255, 196, 196, 196),
        ),
    itemBuilder: (context, index) {
      final drug = viewModel.drugs[index];
      return drugItem(drug: drug);
    },
  );
}

Widget drugItem({required Drug drug}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      children: [
        // 왼쪽: 약 이름과 시간
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drug.drugName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                drug.time,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
        // 오른쪽: 요일과 복용 횟수
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.teal[200],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                drug.day,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${drug.takenDoseCount} / ${drug.totalDoseCount}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ],
    ),
  );
}
