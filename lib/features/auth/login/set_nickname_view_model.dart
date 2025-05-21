import 'package:drug/main_tab_controller.dart';
import 'package:flutter/material.dart';

class SetNicknameViewModel {
  void MoveToHome(BuildContext context, String nickname) {
    print(nickname);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainTabController()),
          (route) => false,
    );
  }
}