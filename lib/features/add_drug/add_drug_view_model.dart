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
    String? time,
    String? day,
    String? totalDoseCountStr,
  }) {
    return Drug(
      id: '', // Firestore에서 자동 생성
      drugName: drugName,
      time: time?.isEmpty == true ? '08:00' : (time ?? '08:00'),
      day: day?.isEmpty == true ? '월' : (day ?? '월'),
      totalDoseCount: int.tryParse(totalDoseCountStr ?? '') ?? 1,
      takenDoseCount: 0,
      createdAt: DateTime.now(), // 현재 시간으로 설정
    );
  }
}
