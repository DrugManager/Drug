import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drug/enums/login_channel.dart';
import 'package:drug/main_tab_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class SetNicknameViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveNickname(String nickname) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('로그인된 사용자가 없습니다.');
    }
    await _firestore.collection('users').doc(user.uid).update({
      'userNickName': nickname,
    });
  }

  Future<void> updateNickname(String newNickname, LoginChannel loginChannel) async {
    String? uid;

    if (loginChannel == LoginChannel.google) {
      uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    } else if (loginChannel == LoginChannel.naver) {
      final res = await FlutterNaverLogin.getCurrentAccount();
      uid = res.id;
    } else if (loginChannel == LoginChannel.kakao){
      uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    } else if (loginChannel == LoginChannel.apple) {
      //todo: apple uid 가져오기
    }
    else {
      throw Exception("Unknown login type");
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'userNickName': newNickname,
    });
  }

  void MoveToHome(BuildContext context, String nickname) async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainTabController()),
          (route) => false,
    );
  }
}