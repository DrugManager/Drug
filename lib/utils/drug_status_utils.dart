import 'package:drug/models/drug_model.dart';

class DrugStatusUtils {
  // 오늘 날짜 범위 내에 있는지 확인
  static bool isTodayInRange(Drug drug) {
    final today = DateTime.now();
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

    return (todayDate.isAfter(startDate) ||
            todayDate.isAtSameMomentAs(startDate)) &&
        (todayDate.isBefore(endDate) || todayDate.isAtSameMomentAs(endDate));
  }

  // 오늘이 올바른 요일인지 확인
  static bool isTodayCorrectWeekday(Drug drug) {
    final today = DateTime.now();
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final todayWeekday = weekdays[today.weekday - 1];
    return drug.weekdays.contains(todayWeekday);
  }

  // 오늘 이미 복용했는지 확인
  static bool hasTakenTodayAlready(Drug drug) {
    final today = DateTime.now();
    final startDate = DateTime(
      drug.startDate.year,
      drug.startDate.month,
      drug.startDate.day,
    );
    final todayDate = DateTime(today.year, today.month, today.day);

    // 시작일부터 오늘까지의 복용 가능한 일수 계산
    int possibleDosesDays = 0;
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(todayDate)) {
      final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final currentWeekday = weekdays[currentDate.weekday - 1];

      // 해당 날짜가 복용 요일인지 확인
      if (drug.weekdays.contains(currentWeekday)) {
        possibleDosesDays++;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // 오늘까지 가능한 복용일수보다 실제 복용횟수가 크거나 같으면 오늘 이미 복용한 것
    return drug.takenDoseCount >= possibleDosesDays;
  }

  // 복용 가능한지 확인
  static bool canTakeDose(Drug drug) {
    if (!isTodayInRange(drug) || !isTodayCorrectWeekday(drug)) {
      return false;
    }
    return !hasTakenTodayAlready(drug);
  }
}
