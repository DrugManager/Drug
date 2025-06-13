//TODO - 약 등록 화면

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/features/add_drug/add_drug_view_model.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AddDrugScreen extends StatefulWidget {
  const AddDrugScreen({super.key});

  @override
  State<AddDrugScreen> createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends State<AddDrugScreen> {
  final AddDrugViewModel _viewModel = AddDrugViewModel();
  final TextEditingController _drugNameController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  Duration _startTime = const Duration(hours: 8);
  Duration _endTime = const Duration(hours: 20);
  bool _isRepeating = false;
  Duration _repeatInterval = const Duration(hours: 8); // 기본 8시간마다 반복

  final List<String> _weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final Set<String> _selectedWeekdays = <String>{};

  @override
  void initState() {
    super.initState();
    // 기본값으로 선택된 요일 없음
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        DateTime selectedDate = isStartDate ? _startDate : _endDate;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isStartDate ? '시작 날짜 선택' : '종료 날짜 선택',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableCalendar<dynamic>(
                          locale: 'ko_KR',
                          firstDay: DateTime.now(),
                          lastDay: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          focusedDay: selectedDate,
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDate, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setModalState(() {
                              selectedDate = selectedDay;
                            });
                          },
                          calendarFormat: CalendarFormat.month,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            weekendStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            selectedDecoration: BoxDecoration(
                              color: mainColor,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: mainColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            weekendTextStyle: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '선택된 날짜: ${DateFormat('yyyy년 MM월 dd일').format(selectedDate)}',
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (isStartDate) {
                                _startDate = selectedDate;
                                if (_endDate.isBefore(_startDate)) {
                                  _endDate = _startDate.add(
                                    const Duration(days: 1),
                                  );
                                }
                              } else {
                                _endDate = selectedDate;
                                if (_endDate.isBefore(_startDate)) {
                                  _startDate = _endDate;
                                }
                              }
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                          ),
                          child: const Text(
                            '확인',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTimePicker(BuildContext context, bool isStartTime) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        Duration selectedTime = isStartTime ? _startTime : _endTime;
        int selectedHours = selectedTime.inHours;
        int selectedMinutes = selectedTime.inMinutes % 60;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    isStartTime ? '시작 시간 선택' : '종료 시간 선택',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        // 시간 선택
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedHours,
                            ),
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedHours = index;
                              });
                            },
                            children: List.generate(24, (index) {
                              return Center(
                                child: Text(
                                  '$index시',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              );
                            }),
                          ),
                        ),
                        // 분 선택
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMinutes,
                            ),
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedMinutes = index;
                              });
                            },
                            children: List.generate(60, (index) {
                              return Center(
                                child: Text(
                                  '$index분',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final newTime = Duration(
                              hours: selectedHours,
                              minutes: selectedMinutes,
                            );
                            if (isStartTime) {
                              _startTime = newTime;
                            } else {
                              _endTime = newTime;
                            }
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRepeatIntervalPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        Duration selectedInterval = _repeatInterval;
        int selectedHours = selectedInterval.inHours;
        int selectedMinutes = selectedInterval.inMinutes % 60;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    '반복 간격 선택',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        // 시간 선택
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedHours,
                            ),
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedHours = index;
                              });
                            },
                            children: List.generate(24, (index) {
                              return Center(
                                child: Text(
                                  '$index시',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              );
                            }),
                          ),
                        ),
                        // 분 선택
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMinutes,
                            ),
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                selectedMinutes = index;
                              });
                            },
                            children: List.generate(60, (index) {
                              return Center(
                                child: Text(
                                  '$index분',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _repeatInterval = Duration(
                              hours: selectedHours,
                              minutes: selectedMinutes,
                            );
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd').format(date);
  }

  String _formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '$hours시 $minutes분';
    } else if (hours > 0) {
      return '$hours시';
    } else {
      return '$minutes분';
    }
  }

  Future<void> _saveDrug() async {
    // 유효성 검사
    final validationError = _viewModel.validateDrugName(
      _drugNameController.text,
    );
    if (validationError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('최소 하나의 요일을 선택해주세요')));
      return;
    }

    // Drug 객체 생성
    final drug = _viewModel.createDrug(
      drugName: _drugNameController.text,
      startDate: _startDate,
      endDate: _endDate,
      weekdays: _selectedWeekdays.toList(),
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
      isRepeating: _isRepeating,
      totalDoseCountStr: '1', // 기본값
    );

    try {
      await _viewModel.addDrug(drug);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('약이 등록되었습니다')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 32, thickness: 1, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('약 등록'),
        titleTextStyle: TextStyle(
          color: mainColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: SizedBox(
          width: 100,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: mainColor, size: 20),
                const SizedBox(width: 4),
                Text('뒤로가기', style: TextStyle(color: mainColor, fontSize: 16)),
              ],
            ),
          ),
        ),
        leadingWidth: 100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약 이름 섹션
            _buildSectionTitle('약 이름'),
            TextField(
              controller: _drugNameController,
              decoration: const InputDecoration(
                hintText: '복용할 약의 이름을 입력하세요',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            _buildDivider(),

            // 복용 기간 섹션 (가로 배치)
            _buildSectionTitle('복용 기간'),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_formatDate(_startDate)),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('~', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_formatDate(_endDate)),
                    ),
                  ),
                ),
              ],
            ),
            _buildDivider(),

            // 요일 반복 섹션 (가로 배치)
            _buildSectionTitle('요일 반복'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  _weekdays.map((weekday) {
                    final isSelected = _selectedWeekdays.contains(weekday);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: FilterChip(
                          label: Text(
                            weekday,
                            style: const TextStyle(fontSize: 12),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedWeekdays.add(weekday);
                              } else {
                                _selectedWeekdays.remove(weekday);
                              }
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: mainColor.withOpacity(0.3),
                          checkmarkColor: mainColor,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            _buildDivider(),

            // 복용 시간 섹션 (가로 배치)
            _buildSectionTitle('복용 시간'),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showTimePicker(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_formatTime(_startTime)),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('~', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _showTimePicker(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_formatTime(_endTime)),
                    ),
                  ),
                ),
              ],
            ),
            _buildDivider(),

            // 반복 설정 섹션
            _buildSectionTitle('반복 설정'),
            Row(
              children: [
                Checkbox(
                  value: _isRepeating,
                  onChanged: (value) {
                    setState(() {
                      _isRepeating = value ?? false;
                    });
                  },
                  activeColor: mainColor,
                ),
                const Text('반복 활성화'),
                const Spacer(),
                if (_isRepeating)
                  InkWell(
                    onTap: () => _showRepeatIntervalPicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_formatDuration(_repeatInterval)}마다',
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            // 등록하기 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveDrug,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '등록하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _drugNameController.dispose();
    super.dispose();
  }
}
