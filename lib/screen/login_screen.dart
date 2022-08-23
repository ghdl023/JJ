import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isKakaoTalkInstalled = false;

  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao install: ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  _loginWithTalk() async {
    print("_loginWithTalk");

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print("token");
      print(token);

      try {
        User user = await UserApi.instance.me();
        print( '사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n이메일: ${user.kakaoAccount?.email}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n프로필사진: ${user.kakaoAccount?.profile?.thumbnailImageUrl}');


        // local storage에 eamil 저장
        final prefs = await SharedPreferences.getInstance();
        int? _id = user.id;
        String? email = user.kakaoAccount?.email;
        if(_id != null) {
          await prefs.setString('kakaoUserId', _id.toString());
          await prefs.setString('kakaoUserEmail', email!);
        }

      } catch (e) {
        print(e.toString());
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top:150.0, bottom: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  width: MediaQuery.of(context).size.width *0.6,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "하",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "루",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "주",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "접",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _isKakaoTalkInstalled ? _loginWithTalk : null,
                  child: Container(
                      width: MediaQuery.of(context).size.width *0.7,
                      height: MediaQuery.of(context).size.height *0.06,
                      padding: EdgeInsets.only(left:15, right:15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _isKakaoTalkInstalled ? HexColor("#FEE500") : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/kakao_icon.png", width: 30,),
                          Container(
                            child: Text(
                              _isKakaoTalkInstalled ? '카카오로 시작하기' : '카카오톡이 설치되어 있지 않습니다.',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize:14,
                              ),
                            ),
                          ),
                          Container(
                            width:20,
                          ),
                        ],
                      )
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
