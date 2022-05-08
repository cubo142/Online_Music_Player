import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/detail_audio_page.dart';
import 'package:online_music_player/my_playlist_page.dart';
import 'package:online_music_player/login/login_page.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart' as AppColors;
import 'model/songs.dart';
import 'my_tabs.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List? popularSongs;
  List? songs;
  ScrollController? _scrollController;
  TabController? _tabController;
  int _selectedIndex = 0;
  PageController pageController = PageController();

  var Firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //fetch dc data nhưng tạm chưa render dc
  List? playList = [];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  // ReadData() async {
  //   await DefaultAssetBundle.of(context)
  //       .loadString("lib/assets/json/popularSongs.json")
  //       .then((s) {
  //     setState(() {
  //       popularSongs = json.decode(s);
  //     });
  //   });
  //   await DefaultAssetBundle.of(context)
  //       .loadString("lib/assets/json/songs.json")
  //       .then((s) {
  //     setState(() {
  //       songs = json.decode(s);
  //     });
  //   });
  // } //popular songs data

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

  }

  Future<List> getSong() async {
    QuerySnapshot querySnapshot = await Firestore.collection('songs').get();
    songList = querySnapshot.docs.map((doc) => doc.data()).toList();
    return songList;
  }

  List songList = [];
  List playlist = [];


  //  getSongID() async {
  //   var collection = FirebaseFirestore.instance.collection('songs');
  //   var querySnapshots = await collection.get();
  //   for (var snapshot in querySnapshots.docs) {
  //     var documentID = snapshot.id; // <-- Document ID
  //     print(documentID);
  //   }
  // }

  addToPlayList() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    QuerySnapshot querySnapshot = await Firestore.collection('user')
        .doc(uid)
        .collection('playlist')
        .get();
    playlist = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < playlist.length; i++) {
      for (int j = 0; j < playlist.length; j++) {
        if (playlist[i]["songID"] == playlist[j]["songID"]) {
          playlist.removeAt(j);
        }
      }
    }
    return playlist;
    // await FirebaseFirestore.instance.collection('playlist').doc(uid)
    //     .collection('songs')
    //     .doc()
    //     .set({
    //   "audio": songList[i]["audio"],
    //   "rating": songList[i]["rating"],
    //   "text": songList[i]["text"],
    //   "img": songList[i]["img"],
    //   "title": songList[i]["title"],
    // });
  }

  @override
  Widget build(BuildContext context) {
    getSong();
    addToPlayList();
    return Container(
        color: AppColors.background,
        child: SafeArea(
          child: Scaffold(
              body: PageView(controller: pageController, children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon(Icons.menu, size: 24, color: Colors.black),
                            Row(
                              children: [
                                Icon(Icons.search),
                                SizedBox(
                                  width: 10,
                                ),
                                // Icon(Icons.notifications),
                              ],
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //         margin: const EdgeInsets.only(left: 20),
                    //         child: Text("Popular Song",
                    //             style: TextStyle(fontSize: 30)))
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //     height: 180,
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //             top: 0,
                    //             left: -20,
                    //             right: 0,
                    //             child: Container(
                    //                 height: 180,
                    //                 child: PageView.builder(
                    //                     controller:
                    //                         PageController(viewportFraction: 0.8),
                    //                     itemCount: popularSongs == null
                    //                         ? 0
                    //                         : popularSongs?.length,
                    //                     itemBuilder: (_, i) {
                    //                       return Container(
                    //                         height: 180,
                    //                         width:
                    //                             MediaQuery.of(context).size.width,
                    //                         margin:
                    //                             const EdgeInsets.only(right: 10),
                    //                         decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(15),
                    //                             image: DecorationImage(
                    //                               image: AssetImage(
                    //                                   popularSongs?[i]["img"]),
                    //                               fit: BoxFit.fill,
                    //                             )),
                    //                       );
                    //                     })))
                    //       ],
                    //     )),
                    Expanded(
                        child: NestedScrollView(
                            controller: _scrollController,
                            headerSliverBuilder:
                                (BuildContext context, bool isScroll) {
                              return [
                                SliverAppBar(
                                  pinned: true,
                                  backgroundColor: AppColors.sliverBackground,
                                  bottom: PreferredSize(
                                    preferredSize: Size.fromHeight(50),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 20, left: 20),
                                      child: TabBar(
                                        indicatorPadding:
                                        const EdgeInsets.all(0),
                                        indicatorSize:
                                        TabBarIndicatorSize.label,
                                        labelPadding:
                                        const EdgeInsets.only(right: 10),
                                        controller: _tabController,
                                        isScrollable: true,
                                        indicator: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 7,
                                                offset: Offset(0, 0),
                                              )
                                            ]),
                                        tabs: [
                                          AppTabs(
                                              color: AppColors.menu1Color,
                                              text: "New"),
                                          AppTabs(
                                              color: AppColors.menu2Color,
                                              text: "Popular"),
                                          AppTabs(
                                              color: AppColors.menu3Color,
                                              text: "Treding"),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ];
                            },
                            body: TabBarView(
                              controller: _tabController,
                              children: [
                                ListView.builder(
                                    itemCount: songList.length,
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailAudioPage(
                                                          songsData: songList,
                                                          index: i)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 10),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color:
                                                  AppColors.tabVarViewColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0),
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                    )
                                                  ]),
                                              child: Container(
                                                  padding:
                                                  const EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                                '${songList[i]["img"]}'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          shape: BoxShape
                                                              .circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(Icons.star,
                                                                  size: 24,
                                                                  color: AppColors
                                                                      .starColor),
                                                              Text(
                                                                songList[i]
                                                                ["rating"],
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .menu2Color),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            songList[i]
                                                            ["title"],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                "Avenir",
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            songList[i]
                                                            ["text"],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                "Avenir",
                                                                color: AppColors
                                                                    .subTitleText),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            width: 60,
                                                            height: 15,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  3),
                                                              color: AppColors
                                                                  .loveColor,
                                                            ),
                                                            child: Text(
                                                              "Love",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                  "Avenir",
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      OutlinedButton(
                                                          onPressed: () async {
                                                            final User? user = auth
                                                                .currentUser;
                                                            final uid = user
                                                                ?.uid;
                                                            // var songTitle= songList[i]["title"];
                                                            // print(songTitle);
                                                            var snapshot = await Firestore
                                                                .collection(
                                                                'user').doc(uid)
                                                                .collection(
                                                                'playlist')
                                                                .where("songID",
                                                                isEqualTo: songList[i]["songID"])
                                                                .get();
                                                            if (snapshot.docs
                                                                .length == 1) {
                                                              print(
                                                                  "document is already exist");
                                                            }
                                                            else {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'user').doc(
                                                                  uid)
                                                                  .collection(
                                                                  'playlist')
                                                                  .doc()
                                                                  .set({
                                                                "audio": songList[i]["audio"],
                                                                "rating": songList[i]["rating"],
                                                                "text": songList[i]["text"],
                                                                "img": songList[i]["img"],
                                                                "title": songList[i]["title"],
                                                                "songID": songList[i]["songID"],
                                                              });
                                                            }
                                                          },
                                                          child:
                                                          Icon(Icons.add))
                                                    ],
                                                  ))),
                                        ),
                                      );
                                    }),
                                ListView.builder(
                                    itemCount:
                                    songs == null ? 0 : songs?.length,
                                    itemBuilder: (_, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color:
                                                AppColors.tabVarViewColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    offset: Offset(0, 0),
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  )
                                                ]),
                                            child: Container(
                                                padding:
                                                const EdgeInsets.all(8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 90,
                                                        height: 120,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                          image:
                                                          DecorationImage(
                                                            image: AssetImage(
                                                                songs?[i]
                                                                ["img"]),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.star,
                                                                size: 24,
                                                                color: AppColors
                                                                    .starColor),
                                                            Text(
                                                              songs?[i]
                                                              ["rating"],
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .menu2Color),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          songs?[i]["title"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                              "Avenir",
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          songs?[i]["text"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                              "Avenir",
                                                              color: AppColors
                                                                  .subTitleText),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: 60,
                                                          height: 15,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                3),
                                                            color: AppColors
                                                                .loveColor,
                                                          ),
                                                          child: Text(
                                                            "Love",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                "Avenir",
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          alignment:
                                                          Alignment.center,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ))),
                                      );
                                    }),
                                ListView.builder(
                                    itemCount:
                                    songs == null ? 0 : songs?.length,
                                    itemBuilder: (_, i) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color:
                                                AppColors.tabVarViewColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    offset: Offset(0, 0),
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  )
                                                ]),
                                            child: Container(
                                                padding:
                                                const EdgeInsets.all(8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 90,
                                                        height: 120,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                          image:
                                                          DecorationImage(
                                                            image: AssetImage(
                                                                songs?[i]
                                                                ["img"]),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.star,
                                                                size: 24,
                                                                color: AppColors
                                                                    .starColor),
                                                            Text(
                                                              songs?[i]
                                                              ["rating"],
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .menu2Color),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          songs?[i]["title"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                              "Avenir",
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          songs?[i]["text"],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                              "Avenir",
                                                              color: AppColors
                                                                  .subTitleText),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: 60,
                                                          height: 15,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                3),
                                                            color: AppColors
                                                                .loveColor,
                                                          ),
                                                          child: Text(
                                                            "Love",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                "Avenir",
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          alignment:
                                                          Alignment.center,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ))),
                                      );
                                    }),
                              ],
                            ))),
                  ],
                ),
                MyPlayListPage()
              ]),
              bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.music_note), label: 'PlayList'),
                ],
                currentIndex: _selectedIndex,
                onTap: onTapped,
              )),
        ));
  }
}
