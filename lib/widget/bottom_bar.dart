import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Container(
        height: 50,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home,
                size: 18,
              ),
              child: Text(
                '주접 보기',
                style: TextStyle(fontSize: 9),
              ),
            ),
            // Tab(
            //   icon: Icon(
            //     Icons.favorite,
            //     size: 18,
            //   ),
            //   child: Text(
            //     '주접 보관함',
            //     style: TextStyle(fontSize: 9),
            //   ),
            // ),
            Tab(
              icon: Icon(
                Icons.settings,
                size: 18,
              ),
              child: Text(
                '설정',
                style: TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}