import 'package:drug/models/drug_model.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/services/drug_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  @override
  void initState() {
    super.initState();
    loadDrugs();
  }

  final Map<DateTime, List<Drug>> _events = {};

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _calendarShrunk = false;

  List<Drug> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  final DrugService _drugService = DrugService();

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
      setState(() {
        _events.clear();
        _events.addAll(generated);
      });

      print('최종 표시될 약 개수: ${allDrugs.length}');
    } catch (e) {
      print('약 목록 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Drug>? events = _selectedDay == null ? null : _getEventsForDay(_selectedDay!);

    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  if (isSameDay(_selectedDay, selectedDay)) {
                    _selectedDay = null;
                    _calendarShrunk = false;
                  } else {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _calendarShrunk = true;
                  }
                });
              },
              eventLoader: _getEventsForDay,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekHeight: _calendarShrunk ? 24 : 36,
              rowHeight: _calendarShrunk ? 40 : 52,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(color: mainColor),
                headerPadding: const EdgeInsets.only(bottom: 8.0, top: 24.0),
                headerMargin: EdgeInsets.only(bottom: _calendarShrunk ? 12 : 42),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                markerDecoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                markersAlignment: Alignment.bottomCenter,
                markersMaxCount: 3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedDay != null)
            Expanded(
              child: (events == null || events.isEmpty)
                  ? const Center(child: Text('이벤트가 없습니다.'))
                  : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final drug = events[index];
                  return ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(drug.drugName),
                    subtitle: Text('${drug.startTime} ~ ${drug.endTime}'),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}