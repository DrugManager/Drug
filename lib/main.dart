import 'package:drug/startup/startup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  final kakaoAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  if (kakaoAppKey == null || kakaoAppKey.isEmpty) {
    debugPrint('KAKAO_NATIVE_APP_KEY가 .env 파일에 정의되지 않았습니다.');
    return;
  }

  KakaoSdk.init(
    nativeAppKey: kakaoAppKey
  );
  await initializeDateFormatting('ko_KR', null);
  runApp(const DrugApp());
}

class DrugApp extends StatelessWidget {
  const DrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('ko', 'KR'), Locale('en', 'US')],
      locale: Locale('ko', 'KR'),
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
