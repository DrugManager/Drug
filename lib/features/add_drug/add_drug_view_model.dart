import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';
import 'package:drug/utils/date_time_utils.dart';
import 'package:drug/utils/validation_utils.dart';
import 'package:drug/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class AddDrugViewModel {
  final DrugService _drugService = DrugService();

  // 약 추가
  Future<void> addDrug(Drug drug) async {
    try {
      await _drugService.addDrug(drug);
    } catch (e) {
      print('약 추가 실패: $e');
      rethrow; // 에러를 다시 던져서 UI에서 처리할 수 있도록
    }
  }

  // 약 수정
  Future<void> updateDrug(Drug drug) async {
    try {
      await _drugService.updateDrug(drug);
    } catch (e) {
      print('약 수정 실패: $e');
      rethrow;
    }
  }

  // 유효성 검사
  String? validateDrugName(String? drugName) {
    return ValidationUtils.validateDrugName(drugName);
  }

  // 입력 유효성 검사
  bool validateInput(String drugName, Set<String> selectedWeekdays) {
    return ValidationUtils.validateInput(drugName, selectedWeekdays);
  }

  // UI 메시지 표시
  void showSuccessMessage(BuildContext context, String message) {
    UIUtils.showSuccessMessage(context, message);
  }

  void showErrorMessage(BuildContext context, String message) {
    UIUtils.showErrorMessage(context, message);
  }

  // 기본값 처리된 Drug 객체 생성
  Drug createDrug({
    required String drugName,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> weekdays,
    required String startTime,
    required String endTime,
    required bool isRepeating,
    required int totalDoseCount,
    required bool hasTotalDoseCount,
  }) {
    return Drug(
      id: '', // Firestore에서 자동 생성
      drugName: drugName,
      startDate: startDate,
      endDate: endDate,
      weekdays: weekdays.isEmpty ? ['월'] : weekdays,
      startTime: startTime.isEmpty ? '08:00' : startTime,
      endTime: endTime.isEmpty ? '20:00' : endTime,
      isRepeating: isRepeating,
      totalDoseCount: totalDoseCount,
      takenDoseCount: 0,
      hasTotalDoseCount: hasTotalDoseCount,
      createdAt: DateTime.now(),
    );
  }

  // 포맷팅 메서드들
  String formatDate(DateTime date) {
    return DateTimeUtils.formatDate(date);
  }

  String formatTime(Duration duration) {
    return DateTimeUtils.formatTime(duration);
  }

  String formatDuration(Duration duration) {
    return DateTimeUtils.formatDuration(duration);
  }

  // 날짜 선택 피커
  Future<void> showDatePickerModal(
    BuildContext context,
    DateTime initialDate,
    String title,
    Function(DateTime) onDateSelected,
  ) async {
    final selectedDate = await UIUtils.showDatePickerModal(
      context,
      initialDate,
      title,
    );
    if (selectedDate != null) {
      onDateSelected(selectedDate);
    }
  }

  // 시간 선택 피커
  Future<void> showTimePickerModal(
    BuildContext context,
    Duration initialTime,
    String title,
    Function(Duration) onTimeSelected,
  ) async {
    final selectedTime = await UIUtils.showTimePickerModal(
      context,
      initialTime,
      title,
    );
    if (selectedTime != null) {
      onTimeSelected(selectedTime);
    }
  }
}
