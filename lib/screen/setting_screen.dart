import 'package:flutter/material.dart';
import 'package:jj/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  String email = '';

  @override
  void initState(){
    super.initState();
    getKakaoUserEmail();
  }

  getKakaoUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _email = prefs.getString('kakaoUserEmail');
    if(_email != null) {
      setState(() {
        email = _email;
      });
    }
  }

  void kakaoLogout() async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("kakaoUserId");
      await prefs.remove("kakaoUserEmail");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);

    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
        // centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left:10, top:15, bottom:15),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color:Colors.white.withOpacity(0.5),
                    width:1.0,
                  )
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(width:5.0),
                Text("카카오 계정")
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left:10, right:10),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  email,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white70
                  ),
                ),
                Flexible(child: Container()),
                InkWell(
                  onTap: kakaoLogout,
                  child: Text("로그아웃",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.yellowAccent
                    ),),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left:10, top:15, bottom:15),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color:Colors.white.withOpacity(0.5),
                    width:1.0,
                  )
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(width:5.0),
                Text("앱 정보")
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left:10, right:10),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "버전",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white70
                  ),
                ),
                Flexible(child: Container()),
                Text(
                  "1.0.0",
                  style: TextStyle(
                    fontSize: 15.0,
                      color: Colors.white70
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
