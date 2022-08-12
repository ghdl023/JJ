import 'package:flutter/material.dart';
import 'package:jj/screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this
  await Firebase.initializeApp();

  KakaoSdk.init(
    nativeAppKey: '3541a223e36b01d9ce4211b799b824a5',
    loggingEnabled: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/bg.png"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "하루주접",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: LoginScreen(),
    );
  }
}