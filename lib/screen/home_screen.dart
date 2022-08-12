import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Item> list = [
    Item.fromMap({
      "sentence": "기억나? 우리 둘이서 루브르 박물관 털러갔는데 너는 조각상인척해서 나만 경찰에 잡혀갔잖아",
      "like": false,
    }),
    Item.fromMap({
      "sentence": "너 감옥 갈뻔했어. 나 심쿵사 할뻔했잖아.",
      "like": false,
    }),
    Item.fromMap({
      "sentence": "나 오늘 수영 배웠어. 너에게 빠져도 살기위해서",
      "like": false,
    }),
    Item.fromMap({
      "sentence": "나 좋은 생각났어. 네 생각",
      "like": false,
    }),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('images').doc('HwdDVYaSJep2uIwMrFAn')
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
  }

  Widget defaultBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(""),
      // ),
      body: Stack(
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
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
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
                  initialPage: 0,
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
                      });
                    }
                  },
                  scrollDirection: Axis.horizontal,
                ),
                items: list.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '2,323명이 이 주접을 좋아하고 있어요!',
                                  style: TextStyle(
                                      fontSize: 15.0
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:15.0,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.7),
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  item.sentence,
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    color: Colors.white.withOpacity(0.9),
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
                                      Text("좋아요",
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        item.like ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 24.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
