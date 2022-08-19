import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


List<String> backgrounds = [
  "assets/images/background/abdul-gani-m-DJ_kZaITX78-unsplash.jpg",
  "assets/images/background/alexander-grey-8XkNFQG_cgk-unsplash.jpg",
  "assets/images/background/alexander-popov-H-FjwCHavfo-unsplash.jpg",
  "assets/images/background/annie-spratt-penahevUgSA-unsplash.jpg",
  "assets/images/background/anthony-tran-LMcvt8Rew4c-unsplash.jpg",
  "assets/images/background/christopher-beloch-P2fBIamIbQk-unsplash.jpg",
  "assets/images/background/elias-maurer-VWP5h4fKfsM-unsplash.jpg",
  "assets/images/background/everton-vila-AsahNlC0VhQ-unsplash.jpg",
  "assets/images/background/freestocks-Y9mWkERHYCU-unsplash.jpg",
  "assets/images/background/jez-timms-bwtgal6MJLM-unsplash.jpg",
  "assets/images/background/jonathan-borba-D67gdIA4OjU-unsplash.jpg",
  "assets/images/background/jonathan-borba-qRNctETJJ_c-unsplash.jpg",
  "assets/images/background/khadeeja-yasser-FHT0KEOwtyg-unsplash.jpg",
  "assets/images/background/leonardo-sanches-b7naustT-1E-unsplash.jpg",
  "assets/images/background/marc-a-sporys-wHaQ4XJ9SgY-unsplash.jpg",
  "assets/images/background/mayur-gala-2PODhmrvLik-unsplash.jpg",
  "assets/images/background/oziel-gomez-L8-0SAy-aoQ-unsplash.jpg",
  "assets/images/background/pablo-heimplatz-OSboZGvoEz4-unsplash.jpg",
  "assets/images/background/tyler-nix-HuneWvWYh-Y-unsplash.jpg",
  "assets/images/background/tyler-nix-Pw5uvsFcGF4-unsplash.jpg",
  "assets/images/background/tyler-nix-sitjgGsVIAs-unsplash.jpg",
];

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
