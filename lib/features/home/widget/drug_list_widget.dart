import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/features/home/widget/drug_list_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget drugList() {
  final viewModel = DrugListViewModel();

  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    itemCount: viewModel.drugs.length,
    separatorBuilder:
        (context, index) => const Divider(
          thickness: 1.4,
          height: 16,
          color: Color.fromARGB(255, 196, 196, 196),
        ),
    itemBuilder: (context, index) {
      final drug = viewModel.drugs[index];
      return drugItem(drug: drug);
    },
  );
}

Widget drugItem({required Drug drug}) {
  return Slidable(
    key: ValueKey(drug.id),
    endActionPane: ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            //TODO: 수정 기능 구현
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${drug.drugName} 수정 기능')));
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: '수정',
        ),
        SlidableAction(
          onPressed: (context) {
            //TODO 삭제 기능 구현
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${drug.drugName} 삭제 기능')));
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: '삭제',
        ),
      ],
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

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
    ),
  );
}
