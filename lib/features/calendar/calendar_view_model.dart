import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';

class CalendarViewModel{
  final DrugService _drugService = DrugService();

  final Map<DateTime, List<Drug>> _events = {};
  Map<DateTime, List<Drug>> get events => _events;

  String _weekdayToKorean(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  Map<DateTime, List<Drug>> _generateEventsFromDrugs(List<Drug> drugs) {
    final Map<DateTime, List<Drug>> events = {};

    for (final drug in drugs) {
      DateTime current = drug.startDate;

      while (!current.isAfter(drug.endDate)) {
        final koreanDay = _weekdayToKorean(current.weekday);
        if (drug.weekdays.contains(koreanDay)) {
          final dateKey = DateTime.utc(current.year, current.month, current.day);
          events.putIfAbsent(dateKey, () => []).add(drug);
        }
        current = current.add(const Duration(days: 1));
      }
    }

    return events;
  }

  Future<void> loadDrugs() async {
    try {
      final allDrugs = await _drugService.getDrugs();
      final generated = _generateEventsFromDrugs(allDrugs);

      _events.clear();
      _events.addAll(generated);
    } catch (e) {
      print('약 목록 불러오기 실패: $e');
    }
  }

  List<Drug> getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }
}