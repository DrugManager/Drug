import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/features/edit_drug/edit_drug_view_model.dart';
import 'package:drug/features/add_drug/widgets/section_title_widget.dart';
import 'package:drug/features/add_drug/widgets/selectable_button_widget.dart';
import 'package:drug/features/add_drug/widgets/weekday_selector_widget.dart';
import 'package:drug/features/add_drug/widgets/total_dose_count_widget.dart';
import 'package:drug/features/add_drug/widgets/repeat_setting_widget.dart';

class EditDrugScreen extends StatefulWidget {
  final Drug drug;

  const EditDrugScreen({super.key, required this.drug});

  @override
  State<EditDrugScreen> createState() => _EditDrugScreenState();
}

class _EditDrugScreenState extends State<EditDrugScreen> {
  final EditDrugViewModel _viewModel = EditDrugViewModel();
  late TextEditingController _drugNameController;
  late TextEditingController _totalDoseCountController;

  late DateTime _startDate;
  late DateTime _endDate;
  late Duration _startTime;
  late Duration _endTime;
  late bool _isRepeating;
  late bool _hasTotalDoseCount;
  Duration _repeatInterval = const Duration(hours: 8);

  final List<String> _weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  late Set<String> _selectedWeekdays;

  @override
  void initState() {
    super.initState();
    _initializeFromDrug();
  }

  void _initializeFromDrug() {
    _drugNameController = TextEditingController(text: widget.drug.drugName);
    _totalDoseCountController = TextEditingController(
      text:
          widget.drug.hasTotalDoseCount
              ? widget.drug.totalDoseCount.toString()
              : '',
    );
    _startDate = widget.drug.startDate;
    _endDate = widget.drug.endDate;
    _selectedWeekdays = Set.from(widget.drug.weekdays);
    _isRepeating = widget.drug.isRepeating;
    _hasTotalDoseCount = widget.drug.hasTotalDoseCount;

    // 시간 파싱
    final startTimeParts = widget.drug.startTime.split(':');
    final endTimeParts = widget.drug.endTime.split(':');

    _startTime = Duration(
      hours: int.tryParse(startTimeParts[0]) ?? 8,
      minutes: int.tryParse(startTimeParts[1]) ?? 0,
    );

    _endTime = Duration(
      hours: int.tryParse(endTimeParts[0]) ?? 20,
      minutes: int.tryParse(endTimeParts[1]) ?? 0,
    );
  }

  void _selectDate(bool isStartDate) {
    _viewModel.showDatePickerModal(
      context,
      isStartDate ? _startDate : _endDate,
      isStartDate ? '시작 날짜 선택' : '종료 날짜 선택',
      (selectedDate) => _updateDate(selectedDate, isStartDate),
    );
  }

  void _updateDate(DateTime selectedDate, bool isStartDate) {
    setState(() {
      if (isStartDate) {
        _startDate = selectedDate;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      } else {
        _endDate = selectedDate;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate;
        }
      }
    });
  }

  void _selectTime(bool isStartTime) {
    _viewModel.showTimePickerModal(
      context,
      isStartTime ? _startTime : _endTime,
      isStartTime ? '시작 시간 선택' : '종료 시간 선택',
      (selectedTime) => _updateTime(selectedTime, isStartTime),
    );
  }

  void _updateTime(Duration selectedTime, bool isStartTime) {
    setState(() {
      if (isStartTime) {
        _startTime = selectedTime;
      } else {
        _endTime = selectedTime;
      }
    });
  }

  void _selectRepeatInterval() {
    _viewModel.showTimePickerModal(context, _repeatInterval, '반복 간격 선택', (
      selectedInterval,
    ) {
      setState(() {
        _repeatInterval = selectedInterval;
      });
    });
  }

  void _toggleWeekday(String weekday, bool selected) {
    setState(() {
      if (selected) {
        _selectedWeekdays.add(weekday);
      } else {
        _selectedWeekdays.remove(weekday);
      }
    });
  }

  Future<void> _updateDrug() async {
    if (!_viewModel.validateInput(
      _drugNameController.text,
      _selectedWeekdays,
    )) {
      return;
    }

    try {
      final totalDoseCount =
          _hasTotalDoseCount
              ? int.tryParse(_totalDoseCountController.text) ??
                  widget.drug.totalDoseCount
              : widget.drug.totalDoseCount;

      final updatedDrug = Drug(
        id: widget.drug.id,
        drugName: _drugNameController.text,
        startDate: _startDate,
        endDate: _endDate,
        weekdays: _selectedWeekdays.toList(),
        startTime: _viewModel.formatTime(_startTime),
        endTime: _viewModel.formatTime(_endTime),
        isRepeating: _isRepeating,
        totalDoseCount: totalDoseCount,
        takenDoseCount: widget.drug.takenDoseCount,
        hasTotalDoseCount: _hasTotalDoseCount,
        createdAt: widget.drug.createdAt,
      );

      await _viewModel.updateDrug(updatedDrug);
      Navigator.pop(context, true);
      _viewModel.showSuccessMessage(context, '약 정보가 수정되었습니다');
    } catch (e) {
      _viewModel.showErrorMessage(context, '수정 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          '약 수정',
          style: TextStyle(
            color: mainColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: SizedBox(
          width: 100,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(Icons.arrow_back, color: mainColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  '뒤로가기',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 16,
                    fontFamily: 'dovemayo',
                  ),
                ),
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
            const SectionTitleWidget(title: '약 이름'),
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
            const Divider(height: 32, thickness: 1, color: Colors.grey),

            // 복용 기간 섹션
            const SectionTitleWidget(title: '복용 기간'),
            Row(
              children: [
                Expanded(
                  child: SelectableButtonWidget(
                    text: _viewModel.formatDate(_startDate),
                    onTap: () => _selectDate(true),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('~', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: SelectableButtonWidget(
                    text: _viewModel.formatDate(_endDate),
                    onTap: () => _selectDate(false),
                  ),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1, color: Colors.grey),

            // 요일 반복 섹션
            const SectionTitleWidget(title: '요일 반복'),
            WeekdaySelectorWidget(
              weekdays: _weekdays,
              selectedWeekdays: _selectedWeekdays,
              onWeekdayToggle: _toggleWeekday,
            ),
            const Divider(height: 32, thickness: 1, color: Colors.grey),

            // 복용 시간 섹션
            const SectionTitleWidget(title: '복용 시간'),
            Row(
              children: [
                Expanded(
                  child: SelectableButtonWidget(
                    text: _viewModel.formatTime(_startTime),
                    onTap: () => _selectTime(true),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('~', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: SelectableButtonWidget(
                    text: _viewModel.formatTime(_endTime),
                    onTap: () => _selectTime(false),
                  ),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1, color: Colors.grey),

            // 총 복용횟수 섹션
            const SectionTitleWidget(title: '총 복용횟수'),
            TotalDoseCountWidget(
              hasTotalDoseCount: _hasTotalDoseCount,
              controller: _totalDoseCountController,
              onChanged: (value) {
                setState(() {
                  _hasTotalDoseCount = value ?? false;
                  if (!_hasTotalDoseCount) {
                    _totalDoseCountController.clear();
                  }
                });
              },
            ),
            const Divider(height: 32, thickness: 1, color: Colors.grey),

            // 반복 설정 섹션
            const SectionTitleWidget(title: '반복 설정'),
            RepeatSettingWidget(
              isRepeating: _isRepeating,
              onChanged: (value) {
                setState(() {
                  _isRepeating = value ?? false;
                });
              },
              onIntervalTap: _isRepeating ? _selectRepeatInterval : null,
              intervalText: _viewModel.formatDuration(_repeatInterval),
            ),

            const SizedBox(height: 40),

            // 수정하기 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateDrug,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '수정하기',
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
    _totalDoseCountController.dispose();
    super.dispose();
  }
}
