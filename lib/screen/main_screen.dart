import 'package:flutter/material.dart';
import 'package:jj/screen/setting_screen.dart';

import '../widget/bottom_bar.dart';
import 'home_screen.dart';
import 'like_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pages = [
    HomeScreen(),
    // LikeScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: pages,
        ),
        bottomNavigationBar: Bottom(),
      ),
    );
  }
}