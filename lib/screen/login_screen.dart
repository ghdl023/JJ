import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

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

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode: authCode);
      print(token);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()),);
    } catch(e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch(e) {
      print(e.toString());
    }
  }

  _loginWithTalk() async {
    print("_loginWithTalk");
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch(e) {
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
                  child: Text(
                      "하        루        주        접",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao,
                  child: Container(
                      width: MediaQuery.of(context).size.width *0.7,
                      height: MediaQuery.of(context).size.height *0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.yellow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble, color: Colors.black.withOpacity(0.8)),
                          SizedBox(width:10,),
                          Text(
                            '카카오톡으로 시작하기',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              fontSize:17,
                            ),
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
