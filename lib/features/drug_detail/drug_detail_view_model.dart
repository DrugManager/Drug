import 'package:flutter/material.dart';
import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';
import 'package:drug/utils/date_time_utils.dart';
import 'package:drug/utils/ui_utils.dart';
import 'package:drug/utils/drug_status_utils.dart';

class DrugDetailViewModel {
  final DrugService _drugService = DrugService();

  // 날짜 포맷팅
  String formatDate(DateTime date) {
    return DateTimeUtils.formatDate(date);
  }

  // 요일 표시 문자열 생성
  String buildWeekdaysDisplay(List<String> weekdays) {
    return DateTimeUtils.buildWeekdaysDisplay(weekdays);
  } // 오늘 날짜 범위 내에 있는지 확인

  bool isTodayInRange(Drug drug) {
    return DrugStatusUtils.isTodayInRange(drug);
  }

  // 오늘이 올바른 요일인지 확인
  bool isTodayCorrectWeekday(Drug drug) {
    return DrugStatusUtils.isTodayCorrectWeekday(drug);
  }

  // 오늘 이미 복용했는지 확인
  bool hasTakenTodayAlready(Drug drug) {
    return DrugStatusUtils.hasTakenTodayAlready(drug);
  }

  // 복용 가능한지 확인
  bool canTakeDose(Drug drug) {
    return DrugStatusUtils.canTakeDose(drug);
  }

  // 복용 완료 처리
  Future<Drug> takeDose(Drug drug) async {
    final updatedDrug = Drug(
      id: drug.id,
      drugName: drug.drugName,
      startDate: drug.startDate,
      endDate: drug.endDate,
      weekdays: drug.weekdays,
      startTime: drug.startTime,
      endTime: drug.endTime,
      isRepeating: drug.isRepeating,
      totalDoseCount: drug.totalDoseCount,
      takenDoseCount: drug.takenDoseCount + 1,
      hasTotalDoseCount: drug.hasTotalDoseCount,
      createdAt: drug.createdAt,
    );

    await _drugService.updateDrug(updatedDrug);
    return updatedDrug;
  }

  // 복용 되돌리기 처리
  Future<Drug> undoTakeDose(Drug drug) async {
    if (drug.takenDoseCount <= 0) {
      throw Exception('되돌릴 복용 기록이 없습니다.');
    }

    final updatedDrug = Drug(
      id: drug.id,
      drugName: drug.drugName,
      startDate: drug.startDate,
      endDate: drug.endDate,
      weekdays: drug.weekdays,
      startTime: drug.startTime,
      endTime: drug.endTime,
      isRepeating: drug.isRepeating,
      totalDoseCount: drug.totalDoseCount,
      takenDoseCount: drug.takenDoseCount - 1,
      hasTotalDoseCount: drug.hasTotalDoseCount,
      createdAt: drug.createdAt,
    );

    await _drugService.updateDrug(updatedDrug);
    return updatedDrug;
  }

  // 성공 메시지 표시
  void showSuccessMessage(BuildContext context, String message) {
    UIUtils.showSuccessMessage(context, message);
  }

  // 에러 메시지 표시
  void showErrorMessage(BuildContext context, String message) {
    UIUtils.showErrorMessage(context, message);
  }

  // 되돌리기 성공 메시지 표시
  void showUndoSuccessMessage(BuildContext context) {
    UIUtils.showUndoSuccessMessage(context);
  }
}
