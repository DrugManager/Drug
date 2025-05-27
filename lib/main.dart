import 'package:drug/startup/startup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  final kakaoAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  KakaoSdk.init(
    nativeAppKey: kakaoAppKey
  );
  runApp(const DrugApp());
}

class DrugApp extends StatelessWidget {
  const DrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: mainColor, centerTitle: true),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: mainColor,
          selectedItemColor: Colors.black,
        ),
        fontFamily: 'dove_mayo',
      ),
      debugShowCheckedModeBanner: false,
      home: StartupScreen(),
    );
  }
}
