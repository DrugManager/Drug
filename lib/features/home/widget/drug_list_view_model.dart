import 'package:drug/models/drug_model.dart';

//TODO - 더미데이터 파이어베이스 수정 필요
class DrugListViewModel {
  final List<Drug> drugs = [
    Drug(
      id: "",
      drugName: '약 이름 1',
      time: '08:00',
      day: '월',
      totalDoseCount: 3,
      takenDoseCount: 1,
    ),
    Drug(
      id: "",
      drugName: '약 이름 2',
      time: '12:00',
      day: '화',
      totalDoseCount: 2,
      takenDoseCount: 0,
    ),
    Drug(
      id: "",
      drugName: '약 이름 3',
      time: '18:00',
      day: '수',
      totalDoseCount: 1,
      takenDoseCount: 1,
    ),
  ];
}
