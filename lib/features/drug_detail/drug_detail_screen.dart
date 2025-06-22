import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/resources/colors.dart';
import 'package:drug/features/drug_detail/drug_detail_view_model.dart';
import 'package:drug/features/drug_detail/widgets/info_row_widget.dart';
import 'package:drug/features/drug_detail/widgets/today_status_widget.dart';
import 'package:drug/features/drug_detail/widgets/action_buttons_widget.dart';

class DrugDetailScreen extends StatefulWidget {
  final Drug drug;

  const DrugDetailScreen({super.key, required this.drug});

  @override
  State<DrugDetailScreen> createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen> {
  final DrugDetailViewModel _viewModel = DrugDetailViewModel();
  late Drug _currentDrug;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentDrug = widget.drug;
  }

  Future<void> _takeDose() async {
    if (!_viewModel.canTakeDose(_currentDrug)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedDrug = await _viewModel.takeDose(_currentDrug);
      setState(() {
        _currentDrug = updatedDrug;
      });
      _viewModel.showSuccessMessage(context, '${_currentDrug.drugName} 복용 완료!');

      // 복용 완료 후 잠시 기다린 다음 목록 새로고침을 위해 결과 반환
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } catch (e) {
      _viewModel.showErrorMessage(context, '복용 기록 실패: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _undoTakeDose() async {
    try {
      final updatedDrug = await _viewModel.undoTakeDose(_currentDrug);
      setState(() {
        _currentDrug = updatedDrug;
      });
      _viewModel.showUndoSuccessMessage(context);

      // 되돌리기 완료 후 잠시 기다린 다음 목록 새로고침을 위해 결과 반환
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } catch (e) {
      _viewModel.showErrorMessage(context, '취소 실패: $e');
    }
  }

  String _getStatusMessage(bool canTake, bool isTodayInRange) {
    if (canTake) {
      return '오늘 복용 가능합니다';
    }

    // 오늘 이미 복용했는지 확인
    final hasTakenToday = _viewModel.hasTakenTodayAlready(_currentDrug);
    if (hasTakenToday && isTodayInRange) {
      return '오늘은 복용했습니다';
    }

    if (isTodayInRange) {
      return '오늘은 복용하지 않는 요일입니다';
    }

    return '복용 기간이 아닙니다';
  }

  Color _getStatusMessageColor(bool canTake, bool isTodayInRange) {
    // 오늘 이미 복용했는지 확인
    final hasTakenToday = _viewModel.hasTakenTodayAlready(_currentDrug);
    if (hasTakenToday && isTodayInRange) {
      return Colors.blue[600]!;
    }

    return canTake ? Colors.green[600]! : Colors.grey[600]!;
  }

  @override
  Widget build(BuildContext context) {
    final canTake = _viewModel.canTakeDose(_currentDrug);
    final isTodayInRange = _viewModel.isTodayInRange(_currentDrug);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentDrug.drugName),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약 이름 섹션
            Text(
              _currentDrug.drugName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 복용횟수 섹션
            Row(
              children: [
                const Text(
                  '복용횟수',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _currentDrug.hasTotalDoseCount
                      ? '${_currentDrug.takenDoseCount} / ${_currentDrug.totalDoseCount}'
                      : '${_currentDrug.takenDoseCount}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // 복용 정보 섹션
            const Text(
              '복용 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InfoRowWidget(
              label: '복용 기간',
              value:
                  '${_viewModel.formatDate(_currentDrug.startDate)} ~ ${_viewModel.formatDate(_currentDrug.endDate)}',
            ),
            InfoRowWidget(
              label: '복용 요일',
              value: _viewModel.buildWeekdaysDisplay(_currentDrug.weekdays),
            ),
            InfoRowWidget(
              label: '복용 시간',
              value: '${_currentDrug.startTime} ~ ${_currentDrug.endTime}',
            ),
            InfoRowWidget(
              label: '반복 설정',
              value: _currentDrug.isRepeating ? '활성화' : '비활성화',
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // 오늘 복용 상태
            TodayStatusWidget(
              canTake: canTake,
              isTodayInRange: isTodayInRange,
              hasTakenToday: _viewModel.hasTakenTodayAlready(_currentDrug),
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusMessage(canTake, isTodayInRange),
              style: TextStyle(
                color: _getStatusMessageColor(canTake, isTodayInRange),
              ),
            ),

            const SizedBox(height: 24),

            // 복용 완료 및 되돌리기 버튼
            ActionButtonsWidget(
              canTake: canTake,
              isLoading: _isLoading,
              takenDoseCount: _currentDrug.takenDoseCount,
              onTakeDose: _takeDose,
              onUndoTakeDose: _undoTakeDose,
            ),
          ],
        ),
      ),
    );
  }
}
