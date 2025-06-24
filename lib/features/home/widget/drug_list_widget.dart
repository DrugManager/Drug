import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/features/home/widget/drug_list_view_model.dart';
import 'package:drug/features/drug_detail/drug_detail_screen.dart';
import 'package:drug/features/edit_drug/edit_drug_screen.dart';
import 'package:drug/enums/drug_sort_type.dart';
import 'package:drug/utils/drug_status_utils.dart';
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

  Future<void> _navigateToDetail(Drug drug) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DrugDetailScreen(drug: drug)),
    );

    if (result == true) {
      await refreshDrugs();
    }
  }

  Future<void> _navigateToEdit(Drug drug) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditDrugScreen(drug: drug)),
    );

    if (result == true) {
      await refreshDrugs();
    }
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

    return Column(
      children: [
        // 정렬 옵션 헤더
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            children: [
              const Text(
                '정렬:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        DrugSortType.values.map((sortType) {
                          final isSelected =
                              _viewModel.currentSortType == sortType;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                sortType.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _viewModel.sortDrugs(sortType);
                                  });
                                }
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.teal,
                              checkmarkColor: Colors.white,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 약 목록
        Expanded(
          child: RefreshIndicator(
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
                return drugItem(
                  drug: drug,
                  onDelete: () => _deleteDrug(drug.id),
                  onEdit: () => _navigateToEdit(drug),
                  onTap: () => _navigateToDetail(drug),
                );
              },
            ),
          ),
        ),
      ],
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

Widget drugItem({
  required Drug drug,
  required VoidCallback onDelete,
  required VoidCallback onEdit,
  required VoidCallback onTap,
}) {
  // 오늘 복용해야 하는 약인지 확인
  final today = DateTime.now();
  final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final todayWeekday = weekdays[today.weekday - 1];

  final todayDate = DateTime(today.year, today.month, today.day);
  final startDate = DateTime(
    drug.startDate.year,
    drug.startDate.month,
    drug.startDate.day,
  );
  final endDate = DateTime(
    drug.endDate.year,
    drug.endDate.month,
    drug.endDate.day,
  );

  final isInDateRange =
      (todayDate.isAfter(startDate) || todayDate.isAtSameMomentAs(startDate)) &&
      (todayDate.isBefore(endDate) || todayDate.isAtSameMomentAs(endDate));
  final isCorrectWeekday = drug.weekdays.contains(todayWeekday);
  final isTodayDrug = isInDateRange && isCorrectWeekday;

  // 오늘 복용 상태 확인
  final hasTakenToday = DrugStatusUtils.hasTakenTodayAlready(drug);

  return Slidable(
    key: ValueKey(drug.id),
    endActionPane: ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            onEdit();
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
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              hasTakenToday && isTodayDrug
                  ? Colors.blue[50] // 복용 완료: 파란색
                  : isTodayDrug
                  ? Colors.teal[50] // 복용 가능: 청록색
                  : Colors.transparent,
          border:
              hasTakenToday && isTodayDrug
                  ? Border.all(color: Colors.blue, width: 1)
                  : isTodayDrug
                  ? Border.all(color: Colors.teal, width: 1)
                  : null,
          borderRadius:
              (isTodayDrug || hasTakenToday) ? BorderRadius.circular(8) : null,
        ),
        child: Row(
          children: [
            // 복용 상태 표시 아이콘
            if (hasTakenToday && isTodayDrug)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              )
            else if (isTodayDrug)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.today, color: Colors.white, size: 16),
              ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                  drug.hasTotalDoseCount
                      ? '${drug.takenDoseCount} / ${drug.totalDoseCount}'
                      : '${drug.takenDoseCount}',
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
    ),
  );
}

Widget _buildWeekdaysDisplay(List<String> weekdays) {
  // 요일을 올바른 순서로 정렬
  List<String> sortedWeekdays = _sortWeekdays(weekdays);

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
        sortedWeekdays.map((weekday) {
          Color backgroundColor;
          if (weekday == '토') {
            backgroundColor = Colors.blue[400]!;
          } else if (weekday == '일') {
            backgroundColor = Colors.red[400]!;
          } else {
            backgroundColor = Colors.teal[200]!;
          }

          return Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(left: 2),
            decoration: BoxDecoration(
              color: backgroundColor,
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

// 요일을 월화수목금토일 순서로 정렬하는 함수
List<String> _sortWeekdays(List<String> weekdays) {
  const weekdayOrder = ['월', '화', '수', '목', '금', '토', '일'];
  List<String> sorted = [];

  for (String day in weekdayOrder) {
    if (weekdays.contains(day)) {
      sorted.add(day);
    }
  }

  return sorted;
}
