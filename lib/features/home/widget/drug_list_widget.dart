import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/features/home/widget/drug_list_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DrugListWidget extends StatefulWidget {
  const DrugListWidget({super.key});

  @override
  State<DrugListWidget> createState() => DrugListWidgetState();
}

class DrugListWidgetState extends State<DrugListWidget> {
  final DrugListViewModel _viewModel = DrugListViewModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDrugs();
  }

  Future<void> _loadDrugs() async {
    await _viewModel.loadDrugs();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> refreshDrugs() async {
    setState(() {
      isLoading = true;
    });
    await _loadDrugs();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.drugs.isEmpty) {
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
      itemCount: _viewModel.drugs.length,
      separatorBuilder:
          (context, index) => const Divider(
            thickness: 1.4,
            height: 16,
            color: Color.fromARGB(255, 196, 196, 196),
          ),
      itemBuilder: (context, index) {
        final drug = _viewModel.drugs[index];
        return drugItem(drug: drug, onDelete: () => _deleteDrug(drug.id));
      },
    );
  }

  Future<void> _deleteDrug(String drugId) async {
    // 삭제 확인 대화상자 표시
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('약 삭제'),
          content: const Text('이 약을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // 사용자가 삭제를 확인한 경우에만 실행
    if (confirmed == true) {
      await _viewModel.deleteDrug(drugId);
      setState(() {});
    }
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
