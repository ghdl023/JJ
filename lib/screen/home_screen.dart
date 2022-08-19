import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clipboard/clipboard.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/model_item.dart';
import 'background_setting_screen.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  int lastJooJubIndex = 0;

  late String kakaoUserId;
  String background_image = backgrounds[0];

  bool showLikePosts = false;


  @override
  void initState() {
    super.initState();
    // print("home init!!!!");
    getKakaoUserId();
    getBackgroundImage();
  }

  getKakaoUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _id = prefs.getString('kakaoUserId');
    if(_id != null) {
      setState(() {
        kakaoUserId = _id;
      });
    }
  }

  getBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _imageUrl = prefs.getString('background_image');
    if(_imageUrl != null) {
      setState(() {
        background_image = _imageUrl;
      });
      precacheImage(AssetImage(background_image), context);
    }
  }

  bool _isFavoriteByItem(var item) {
    bool isLike = false;
    print(kakaoUserId);
    print(item["like_users"]);
    if(item["like_users"][kakaoUserId] != null) {
      isLike = item["like_users"][kakaoUserId];
    }
    return isLike;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('joojubs').snapshots(),
            builder: (context, snapshot) {
              // print("joojubs snapshot:");
              // print(snapshot);
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              var joojubList = [];
              if(snapshot.data!.docs.isNotEmpty) {
                joojubList = snapshot.data!.docs;
                if(showLikePosts) {
                  joojubList = joojubList.where((element) => _isFavoriteByItem(element)).toList();
                }
              }
              return Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(background_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: double.infinity,
                          viewportFraction: 1,
                          initialPage: lastJooJubIndex,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 15),
                          autoPlayAnimationDuration: Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, CarouselPageChangedReason reason) {
                            setState(() {
                              if(joojubList.length-1 > lastJooJubIndex) {
                                lastJooJubIndex++;
                              } else {
                                lastJooJubIndex = 0;
                              }
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                        items: joojubList.map((item) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            '이 주접을 ${item["like_count"]}명의 사람들이 좋아해요',
                                            style: TextStyle(
                                                fontSize: 12.0
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height:15.0,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            FlutterClipboard.copy(item["sentence"]).then(( value ) {
                                              print('copied');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '주접이 클립보드에 복사되었습니다. 😍',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.black54,
                                                  duration: Duration(milliseconds: 3000),
                                                  behavior: SnackBarBehavior.floating,
                                                  // action: SnackBarAction(
                                                  //   label: 'Undo',
                                                  //   textColor: Colors.white,
                                                  //   onPressed: () => print('Pressed'),
                                                  // ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    // side: BorderSide(
                                                    //   color: Colors.red,
                                                    //   width: 2,
                                                    // ),
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left:10, right:10),
                                            padding: EdgeInsets.only(left: 15.0, right:15.0, top: 30, bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.7),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  item["sentence"],
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white.withOpacity(0.9),
                                                  ),
                                                ),
                                                SizedBox(height:10),
                                                Container(
                                                  width:double.infinity,
                                                  alignment: Alignment.bottomRight,
                                                  child: Text(
                                                    'copy',
                                                    style: TextStyle(
                                                      fontSize: 11.0,
                                                      color: Colors.white.withOpacity(0.7),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 100,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              FavoriteButton(
                                                isFavorite: _isFavoriteByItem(item), // false,
                                                // iconDisabledColor: Colors.white,
                                                iconSize: 80,
                                                valueChanged: (_isFavorite) async {
                                                  print('Is Favorite : $_isFavorite');

                                                  var documentSnapshot  = await firestore.collection("joojubs").doc(item["doc_id"]).get();
                                                  print("docId is " + item["doc_id"]);
                                                  firestore.collection("joojubs").doc(item["doc_id"]).update(
                                                      {
                                                        'like_count': _isFavorite ? documentSnapshot["like_count"]+1 : documentSnapshot["like_count"]-1,
                                                        'like_users.${kakaoUserId}' : _isFavorite,
                                                      });
                                                },
                                              ),
                                              SizedBox(height:5),
                                              Container(
                                                child: Text(
                                                  _isFavoriteByItem(item) ? "좋아요!" : "이 주접이 마음에드신다면 좋아요를 눌러주세요.",
                                                  style: TextStyle(
                                                    fontSize: 11.0,
                                                    color: Colors.white.withOpacity(0.87)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                  ),
                                ],
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showLikePosts = !showLikePosts;
                        });
                      },
                      child: Container(
                        child: Text(
                          showLikePosts ? "모두 보기" : "좋아요만 보기",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ),
                  ), // 좋아요만 보기, 모두 보기
                  Positioned(
                    top: 50,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BackgroundSettingScreen()))
                            .then((value) => {
                              getBackgroundImage()
                          });
                        });
                      },
                      child: Container(
                        child: Text(
                          "배경 이미지",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ),
                  ), // 배경화면 설정
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}