import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/features/home/widget/drug_list_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DrugListWidget extends StatefulWidget {
  final VoidCallback? onRefresh;

  const DrugListWidget({super.key, this.onRefresh});

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
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
  }

  Future<void> _onRefresh() async {
    await refreshDrugs();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.drugs.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: Center(
              child: Text(
                '등록된 약이 없습니다.\n+ 버튼을 눌러 약을 등록해보세요!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
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
      ),
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
          // 왼쪽: 약 이름과 복용기간
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
                  '${drug.startTime} - ${drug.endTime}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
          // 오른쪽: 요일들과 횟수
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 요일들을 가로로 나열 (모든 요일 선택 시 "매일" 표시)
              _buildWeekdaysDisplay(drug.weekdays),
              const SizedBox(height: 4),
              // 복용 횟수 표시
              Text(
                '${drug.takenDoseCount} / ${drug.totalDoseCount}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildWeekdaysDisplay(List<String> weekdays) {
  // 모든 요일이 선택된 경우 "매일" 표시
  if (weekdays.length == 7) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '매일',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // 일부 요일만 선택된 경우 각 요일을 원형 버튼으로 표시
  return Row(
    mainAxisSize: MainAxisSize.min,
    children:
        weekdays.map((weekday) {
          return Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              color: Colors.teal[200],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              weekday,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
  );
}
