import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drug/features/auth/login/login_view_model.dart';
import 'package:drug/widgets/social_login_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginViewModel();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "어서오세요",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24,),
                    const Text(
                      "메디안 스토리",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 100,),
                    SocialLoginButton(
                      imagePath: 'assets/naver_icon.png',
                      text: '네이버아이디로 로그인',
                      textColor: Colors.green,
                      borderColor: Colors.green,
                      backgroundColor: Colors.white,
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                        try{
                          final user = await viewModel.signInWithNaver();
                          if (user == null) return;

                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .get();
                          await viewModel.storeLoginChannel('naver');

                          if (userDoc.exists) {
                            viewModel.MoveToHome(context);
                          } else {
                            await viewModel.saveUserInfo(
                              context: context,
                              loginChannel: 2,
                              naverUser: user,
                            );
                          }
                        }finally{
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                        },
                    ),
                    const SizedBox(height: 10,),
                    SocialLoginButton(
                      imagePath: 'assets/kakaotalk_icon.png',
                      text: '카카오아이디로 로그인',
                      textColor: Colors.yellow,
                      borderColor: Colors.yellow,
                      backgroundColor: Colors.white,
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                        try{
                          final user = await viewModel.signInWithKakao();
                          if (user == null) return;

                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();
                          await viewModel.storeLoginChannel('kakao');

                          if (userDoc.exists) {
                            viewModel.MoveToHome(context);
                          } else {
                            await viewModel.saveUserInfo(
                              context: context,
                              loginChannel: 3,
                              firebaseUser: user,
                            );
                          }
                        }finally{
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                        },
                    ),
                    const SizedBox(height: 10,),
                    SocialLoginButton(
                      imagePath: 'assets/google_icon.png',
                      text: '구글아이디로 로그인',
                      textColor: Color(0xFFEB4F4D),
                      borderColor: Color(0xFFEB4F4D),
                      backgroundColor: Colors.white,
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                        try{
                          final user = await viewModel.signInWithGoogle();
                          if (user == null) return;

                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();
                          await viewModel.storeLoginChannel('google');

                          if (userDoc.exists) {
                            viewModel.MoveToHome(context);
                          } else {
                            await viewModel.saveUserInfo(
                                context: context,
                                loginChannel: 1,
                                firebaseUser: user
                            );
                          }
                        }finally{
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                        },
                    ),
                    const SizedBox(height: 10,),
                    SocialLoginButton(
                      imagePath: 'assets/apple_icon.png',
                      text: 'Apple 아이디로 로그인',
                      textColor: Colors.black,
                      borderColor: Colors.black,
                      backgroundColor: Colors.white,
                      onPressed: () => viewModel.login(context),
                    ),
                  ],
                ),
              )
          ),
        ),
        if (isLoading)
          Container(
            color: const Color.fromRGBO(255, 255, 255, 0.8),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
