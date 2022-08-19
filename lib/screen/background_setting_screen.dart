import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/home_screen.dart';

class BackgroundSettingScreen extends StatefulWidget {
  const BackgroundSettingScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundSettingScreen> createState() => _BackgroundSettingScreenState();
}

class _BackgroundSettingScreenState extends State<BackgroundSettingScreen> {
  @override
  Widget build(BuildContext context) {
    for(int i=0; i<backgrounds.length; i++) {
      precacheImage(AssetImage(backgrounds[i]), context);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("배경 이미지"),
      ),
      body: GridView.builder(
          itemCount: backgrounds.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(5),
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('background_image', backgrounds[index]);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage(backgrounds[index]),
                              fit: BoxFit.cover)
                      )
                  ),
                ),
            );
          }),
    );
  }
}
