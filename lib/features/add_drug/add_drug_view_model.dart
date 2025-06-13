import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';

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

  // 유효성 검사
  String? validateDrugName(String? drugName) {
    if (drugName == null || drugName.isEmpty) {
      return '약 이름을 입력해주세요';
    }
    return null;
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
    String? totalDoseCountStr,
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
      totalDoseCount: int.tryParse(totalDoseCountStr ?? '') ?? 1,
      takenDoseCount: 0,
      createdAt: DateTime.now(),
    );
  }
}
