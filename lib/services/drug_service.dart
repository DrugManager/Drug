import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drug/models/drug_model.dart';

class DrugService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 약 추가
  Future<void> addDrug(Drug drug) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('drugs')
        .add(drug.toJson());
  }

  // 약 목록 조회 (Stream으로 실시간 업데이트)
  Stream<List<Drug>> getDrugsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('drugs')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Drug.fromJson(doc.data(), doc.id))
                  .toList(),
        );
  }

  // 약 목록 조회 (기존 방식 유지)
  Future<List<Drug>> getDrugs() async {
    final user = _auth.currentUser;
    print('현재 사용자: ${user?.uid}');
    print('현재 사용자 이메일: ${user?.email}');

    if (user == null) {
      print('사용자가 로그인되지 않음');
      return [];
    }

    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('drugs')
              .get();

      print('조회된 문서 수: ${querySnapshot.docs.length}');

      final drugs =
          querySnapshot.docs.map((doc) {
            print('문서 ID: ${doc.id}, 데이터: ${doc.data()}');
            return Drug.fromJson(doc.data(), doc.id);
          }).toList();

      print('변환된 약 개수: ${drugs.length}');
      return drugs;
    } catch (e) {
      print('약 목록 조회 오류: $e');
      return [];
    }
  }

  // 약 삭제
  Future<void> deleteDrug(String drugId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('drugs')
        .doc(drugId)
        .delete();
  }

  // 약 업데이트 (복용 횟수 증가 등)
  Future<void> updateDrug(Drug drug) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('updateDrug: 사용자가 로그인되지 않음');
      return;
    }

    try {
      print(
        'updateDrug: 약 업데이트 시작 - ID: ${drug.id}, 복용횟수: ${drug.takenDoseCount}',
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('drugs')
          .doc(drug.id)
          .update(drug.toJson());

      print('updateDrug: 약 업데이트 완료');
    } catch (e) {
      print('updateDrug: 약 업데이트 실패 - $e');
      rethrow;
    }
  }
}
