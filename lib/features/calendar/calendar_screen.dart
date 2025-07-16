import 'package:drug/features/calendar/calendar_view_model.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarViewModel viewModel = CalendarViewModel();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _calendarShrunk = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDrugEvents();
  }

  Future<void> loadDrugEvents() async {
    await viewModel.loadDrugs();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Drug>? events = _selectedDay == null
        ? null
        : viewModel.getEventsForDay(_selectedDay!);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day),
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
              eventLoader: viewModel.getEventsForDay,
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
                headerPadding:
                const EdgeInsets.only(bottom: 8.0, top: 24.0),
                headerMargin:
                EdgeInsets.only(bottom: _calendarShrunk ? 12 : 42),
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
                selectedTextStyle:
                const TextStyle(color: Colors.white),
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
                    subtitle:
                    Text('${drug.startTime} ~ ${drug.endTime}'),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}