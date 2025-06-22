import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';
import 'package:drug/utils/date_time_utils.dart';
import 'package:drug/utils/validation_utils.dart';
import 'package:drug/utils/ui_utils.dart';

class EditDrugViewModel {
  final DrugService _drugService = DrugService();

  // 날짜 포맷팅
  String formatDate(DateTime date) {
    return DateTimeUtils.formatDate(date);
  }

  // 시간 포맷팅
  String formatTime(Duration time) {
    return DateTimeUtils.formatTime(time);
  }

  // Duration 포맷팅
  String formatDuration(Duration duration) {
    return DateTimeUtils.formatDuration(duration);
  }

  // 시간 파싱
  Duration parseTime(String timeString) {
    return DateTimeUtils.parseTime(timeString);
  }

  // 입력 유효성 검사
  bool validateInput(String drugName, Set<String> selectedWeekdays) {
    return ValidationUtils.validateInput(drugName, selectedWeekdays);
  }

  // 약 업데이트
  Future<void> updateDrug(Drug drug) async {
    await _drugService.updateDrug(drug);
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

  // 성공 메시지 표시
  void showSuccessMessage(BuildContext context, String message) {
    UIUtils.showSuccessMessage(context, message);
  }

  // 에러 메시지 표시
  void showErrorMessage(BuildContext context, String message) {
    UIUtils.showErrorMessage(context, message);
  }
}
