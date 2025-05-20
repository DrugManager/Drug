import 'package:drug/features/auth/login/login_view_model.dart';
import 'package:drug/widgets/social_login_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = LoginViewModel();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                onPressed: () => viewModel.login(context),
              ),
              const SizedBox(height: 10,),
              SocialLoginButton(
                imagePath: 'assets/kakaotalk_icon.png',
                text: '카카오아이디로 로그인',
                textColor: Colors.yellow,
                borderColor: Colors.yellow,
                backgroundColor: Colors.white,
                onPressed: () => viewModel.login(context),
              ),
              const SizedBox(height: 10,),
              SocialLoginButton(
                imagePath: 'assets/google_icon.png',
                text: '구글아이디로 로그인',
                textColor: Color(0xFFEB4F4D),
                borderColor: Color(0xFFEB4F4D),
                backgroundColor: Colors.white,
                onPressed: () => viewModel.login(context),
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
    );
  }
}