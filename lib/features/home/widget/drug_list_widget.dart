import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DrugListWidget extends StatefulWidget {
  const DrugListWidget({super.key});

  @override
  State<DrugListWidget> createState() => DrugListWidgetState();
}

class DrugListWidgetState extends State<DrugListWidget> {
  final DrugService _drugService = DrugService();

  // 외부에서 호출 가능한 새로고침 메서드 (StreamBuilder 사용시에는 필요 없지만 호환성을 위해 유지)
  Future<void> refreshDrugs() async {
    // StreamBuilder를 사용하므로 별도의 새로고침이 필요 없음
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Drug>>(
      stream: _drugService.getDrugsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
        }

        final drugs = snapshot.data ?? [];

        if (drugs.isEmpty) {
          return const Center(
            child: Text(
              '등록된 약이 없습니다.\n+ 버튼을 눌러 약을 등록해보세요!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          itemCount: drugs.length,
          separatorBuilder:
              (context, index) => const Divider(
                thickness: 1.4,
                height: 16,
                color: Color.fromARGB(255, 196, 196, 196),
              ),
          itemBuilder: (context, index) {
            final drug = drugs[index];
            return drugItem(drug: drug, onDelete: () => _deleteDrug(drug.id));
          },
        );
      },
    );
  }

  Future<void> _deleteDrug(String drugId) async {
    await _drugService.deleteDrug(drugId);
    // StreamBuilder가 자동으로 UI를 업데이트하므로 setState 불필요
  }
}

Widget drugItem({required Drug drug, required VoidCallback onDelete}) {
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
            onDelete();
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
