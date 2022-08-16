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
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  List<dynamic> backgroundImages = [];
  int currentBackgroundImageIndex = 0;
  int lastJooJubIndex = 0;

  late String kakaoUserId;


  @override
  void initState() {
    super.initState();
    // print("home init!!!!");
    firestore.collection('images').doc('HwdDVYaSJep2uIwMrFAn')
        .get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        if(data["list"].isNotEmpty) {
          setState(() {
            backgroundImages = data["list"];
          });
          print("backgroundImages");
          print(backgroundImages);
        }
      } else {
        print('Document does not exist on the database');
      }
    });

    getKakaoUserId();
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

  Widget defaultBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
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
      // appBar: AppBar(
      //   title: Text(""),
      // ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('joojubs').snapshots(),
            builder: (context, snapshot) {
              // print("joojubs snapshot:");
              // print(snapshot);
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container();
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              var joojubList = [];
              if(snapshot.data!.docs.isNotEmpty) {
                joojubList = snapshot.data!.docs;
              }
              return Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: backgroundImages.isNotEmpty ? CachedNetworkImage(
                      imageUrl: backgroundImages[currentBackgroundImageIndex],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // progressIndicatorBuilder: (context, url, downloadProgress) =>
                      //     CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => defaultBackgroundImage(),
                    ) : defaultBackgroundImage(),
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
                            if(backgroundImages.isNotEmpty) {
                              Random random = new Random();
                              int randomNumber = random.nextInt(backgroundImages.length);
                              if(randomNumber == currentBackgroundImageIndex) {
                                randomNumber = randomNumber > 0 ? randomNumber-1 : randomNumber+1;
                              }
                              setState(() {
                                currentBackgroundImageIndex = randomNumber;
                                if(joojubList.length-1 > lastJooJubIndex) {
                                  lastJooJubIndex++;
                                } else {
                                  lastJooJubIndex = 0;
                                }
                              });

                            }
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                        items: joojubList.map((item) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          '${item["like_count"]}명이 이 주접을 좋아하고 있어요!',
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
                                      SizedBox(
                                        height:25.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // Text("좋아요",
                                              //   style: TextStyle(
                                              //     fontSize: 24.0,
                                              //     color: Colors.white,
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   width: 5.0,
                                              // ),
                                              FavoriteButton(
                                                isFavorite: _isFavoriteByItem(item), // false,
                                                // iconDisabledColor: Colors.white,
                                                valueChanged: (_isFavorite) async {
                                                  print('Is Favorite : $_isFavorite');

                                                  var documentSnapshot  = await firestore.collection("joojubs").doc(item["doc_id"]).get();
                                                  // var doc  = await firestore.collection("joojubs").doc(item["doc_id"]);
                                                  print("docId is " + item["doc_id"]);
                                                  firestore.collection("joojubs").doc(item["doc_id"]).update(
                                                      {
                                                        'like_count': _isFavorite ? documentSnapshot["like_count"]+1 : documentSnapshot["like_count"]-1,
                                                        'like_users.${kakaoUserId}' : _isFavorite,
                                                      });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          if(false)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
