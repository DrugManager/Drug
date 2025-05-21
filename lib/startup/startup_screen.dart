import 'package:drug/features/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:drug/main_tab_controller.dart';

Future<bool> isLoggedIn() async {
  await Future.delayed(Duration(seconds: 1)); // 테스트용 딜레이
  return false; // 로그인 안 되어 있다고 가정
}

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16,),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const StartupScreen()
                          ),
                        );
                      },
                      child: const Text('Retry'),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const MainTabController(); // 로그인 되어 있음
        } else {
          return const LoginScreen(); // 로그인 안 되어 있음
        }
      },
    );
  }
}
