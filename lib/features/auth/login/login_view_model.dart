import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drug/enums/login_channel.dart';
import 'package:drug/features/auth/login/set_nickname_screen.dart';
import 'package:drug/main_tab_controller.dart';
import 'package:drug/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_account_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao_user;
import 'package:shared_preferences/shared_preferences.dart';


class LoginViewModel {
  void login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetNickname()),
    );
  }

  Future<firebase_auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      var credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google 로그인 실패: $e");
      return null;
    }
  }

  Future<NaverAccountResult?> signInWithNaver() async {
    //네이버 로그인 인증 후 유저정보 가져오기
    try {
      final NaverLoginResult res = await FlutterNaverLogin.logIn();

      if (res.status == NaverLoginStatus.loggedIn && res.account != null) {
        return res.account;
      } else {
        print("네이버 로그인 실패: ${res.status}");
        return null;
      }
    } catch (error) {
      print("로그인 중 에러 발생: $error");
      return null;
    }
  }

  Future<firebase_auth.User?> signInWithKakao() async {
    //카카오, firebase OpenID Connect 연동 인증
    var provider = firebase_auth.OAuthProvider("oidc.medianstory");
    kakao_user.OAuthToken token = await kakao_user.UserApi.instance.loginWithKakaoAccount();
    var credential = provider.credential(
      idToken: token.idToken,
      accessToken: token.accessToken,
    );
    final userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;

    //카카오 인증 후, kakao_user.User 타입으로 카카오 유저 정보를 받아서 처리 가능, 필요시 사용
    /*
    final kakao_user.OAuthToken token = await kakao_user.UserApi.instance.loginWithKakaoAccount();
    print('카카오 로그인 성공: ${token.accessToken}');
    final user = await kakao_user.UserApi.instance.me();
    print('카카오 사용자 정보: ${user.id}, ${user.kakaoAccount?.email}');
    */
  }

  //todo: 애플로그인 처리하기

  Future<void> saveUserInfo({
    required BuildContext context,
    required LoginChannel loginChannel,
    firebase_auth.User? firebaseUser,
    NaverAccountResult? naverUser,
  }) async {
    String uid = '';
    String name = '';
    String nickname = '';

    // 채널에 따라 분기 처리
    switch (loginChannel) {
      case LoginChannel.google:
        if (firebaseUser != null) {
          uid = firebaseUser.uid;
          name = firebaseUser.displayName ?? '';
          nickname = '구글유저 ${firebaseUser.displayName}';
        }
        break;

      case LoginChannel.naver:
        if (naverUser != null) {
          uid = naverUser.id ?? 'naver_uid';
          name = naverUser.name ?? '';
          nickname = naverUser.nickname ?? '네이버유저';
        }
        break;

      case LoginChannel.kakao:
        if (firebaseUser != null) {
          uid = firebaseUser.uid;
          name = firebaseUser.displayName ?? '';
          nickname = '카카오유저 ${firebaseUser.displayName}';
        }
        break;

      case LoginChannel.apple:
        //todo: 애플유저 정보 저장
        break;

      default:
        print("지원되지 않는 로그인 채널 또는 정보 없음");
        return;
    }

    final userModel = UserModel(
      uid: uid,
      userNickName: nickname,
      loginChannel: loginChannel.code,
      userName: name,
      subscribeDate: DateTime.now().toIso8601String(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toMap());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetNickname()),
    );
  }

  Future<void> storeLoginChannel(LoginChannel loginChannel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loginChannel', loginChannel.code);
  }

  Future<LoginChannel?> getLoginChannel() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getInt('loginchannel');
    if (code != null) {
      try {
        return LoginChannelCode.fromCode(code);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  //홈화면으로 이동
  void MoveToHome(BuildContext context) async{
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainTabController()),
          (route) => false,
    );
  }

}