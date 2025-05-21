import 'package:drug/features/auth/login/set_nickname_screen.dart';
import 'package:flutter/material.dart';

class LoginViewModel {
  void login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetNickname()),
    );
  }
}