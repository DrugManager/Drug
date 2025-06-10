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
    if (user == null) return [];

    final querySnapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('drugs')
            .get();

    return querySnapshot.docs
        .map((doc) => Drug.fromJson(doc.data(), doc.id))
        .toList();
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
}
