import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';
import 'package:drug/enums/drug_sort_type.dart';

class DrugListViewModel {
  final DrugService _drugService = DrugService();
  List<Drug> drugs = [];
  DrugSortType currentSortType = DrugSortType.todayRelevant;

  // Firestore에서 약 목록 불러오기
  Future<void> loadDrugs() async {
    try {
      final allDrugs = await _drugService.getDrugs();

      // 활성화된 약만 필터링 (종료되지 않은 약)
      drugs = _filterActiveDrugs(allDrugs);

      // 현재 선택된 정렬 방식으로 정렬
      sortDrugs(currentSortType);

      print('최종 표시될 약 개수: ${drugs.length}');
    } catch (e) {
      print('약 목록 불러오기 실패: $e');
    }
  }

  // 정렬 기능
  void sortDrugs(DrugSortType sortType) {
    currentSortType = sortType;

    switch (sortType) {
      case DrugSortType.todayRelevant:
        _sortByTodayRelevant();
        break;
      case DrugSortType.createdDate:
        drugs.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순
        break;
      case DrugSortType.startDate:
        drugs.sort((a, b) => a.startDate.compareTo(b.startDate)); // 시작일 빠른순
        break;
      case DrugSortType.drugName:
        drugs.sort((a, b) => a.drugName.compareTo(b.drugName)); // 가나다순
        break;
    }
  }

  // 오늘 복용해야 하는 약을 위로 정렬
  void _sortByTodayRelevant() {
    final today = DateTime.now();
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final todayWeekday = weekdays[today.weekday - 1];

    drugs.sort((a, b) {
      final aIsToday = _isDrugForToday(a, today, todayWeekday);
      final bIsToday = _isDrugForToday(b, today, todayWeekday);

      if (aIsToday && !bIsToday) return -1; // a가 오늘 복용약이면 위로
      if (!aIsToday && bIsToday) return 1; // b가 오늘 복용약이면 위로

      // 둘 다 오늘 복용약이거나 둘 다 아니면 생성일순
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  // 오늘 복용해야 하는 약인지 확인
  bool _isDrugForToday(Drug drug, DateTime today, String todayWeekday) {
    // 날짜 범위 확인
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
        (todayDate.isAfter(startDate) ||
            todayDate.isAtSameMomentAs(startDate)) &&
        (todayDate.isBefore(endDate) || todayDate.isAtSameMomentAs(endDate));

    // 요일 확인
    final isCorrectWeekday = drug.weekdays.contains(todayWeekday);

    return isInDateRange && isCorrectWeekday;
  }

  // 활성화된 약만 필터링 (종료 날짜가 지나지 않은 약)
  List<Drug> _filterActiveDrugs(List<Drug> allDrugs) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return allDrugs.where((drug) {
      // 종료 날짜의 시/분/초를 0으로 설정하여 날짜만 비교
      final endDate = DateTime(
        drug.endDate.year,
        drug.endDate.month,
        drug.endDate.day,
      );

      // 오늘이 종료날짜와 같거나 이전이면 활성화
      return !todayDate.isAfter(endDate);
    }).toList();
  }

  // 약 삭제
  Future<void> deleteDrug(String drugId) async {
    try {
      await _drugService.deleteDrug(drugId);
      drugs.removeWhere((drug) => drug.id == drugId);
    } catch (e) {
      print('약 삭제 실패: $e');
    }
  }
}
