import 'package:drug/models/drug_model.dart';
import 'package:drug/services/drug_service.dart';

class DrugListViewModel {
  final DrugService _drugService = DrugService();
  List<Drug> drugs = [];

  // Firestore에서 약 목록 불러오기
  Future<void> loadDrugs() async {
    try {
      drugs = await _drugService.getDrugs();
    } catch (e) {
      print('약 목록 불러오기 실패: $e');
    }
  }

  // 약 삭제
  Future<void> deleteDrug(String drugId) async {
    try {
      await _drugService.deleteDrug(drugId);
      drugs.removeWhere((drug) => drug.id == drugId);
    } catch (e) {
      print('약 삭제 실패: $e');
    }
  }
}
