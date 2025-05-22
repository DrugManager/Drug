import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drug/features/auth/login/set_nickname_screen.dart';
import 'package:drug/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginViewModel {
  void login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetNickname()),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google 로그인 실패: $e");
      return null;
    }
  }

  Future<void> saveUserInfo(context, User user) async {
    final userModel = UserModel(
      uid: user.uid,
      userNickName: '기본닉네임',
      loginChannel: 1, // 예: 1 = Google
      userName: user.displayName ?? '',
      subscribeDate: DateTime.now().toIso8601String(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetNickname()),
    );
  }
}