import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/Services/AuthenticationService.dart';
import 'package:online_music_player/detail_audio_page.dart';
import 'package:online_music_player/my_playlist_page.dart';
import 'package:online_music_player/login/login_page.dart';
import 'package:online_music_player/profile_page.dart';
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
  String? userEmail;
  bool? isLogin;

  var Firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void checkExisted(){
    bool isPlaying = true;
    int currentSong = 2;
    List song = [1,2,3,4,5,6,7,8];
    List tempList = [];
    List playedSong = song.where((s) => s == currentSong ).toList();
    if(isPlaying == true){
      for(int i = 0;i<playedSong.length;i++){
        tempList.add(i);
      }
    }
    print(tempList);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    isLogin = true;
    // final User? user = auth.currentUser;
  }

  @override
  void dispose(){
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    QuerySnapshot qr = await Firestore.collection('songs').where('title', isGreaterThanOrEqualTo: name).get();
    songList = qr.docs.map((doc) => doc.data()).toList();
    // QuerySnapshot querySnapshot = await Firestore.collection('songs').get();
    // songList = querySnapshot.docs.map((doc) => doc.data()).toList();
    final user = await auth.currentUser;
    if(user != null){
      setState(() {
        userEmail = user?.email;
        isLogin = true;
      });
    } else if ( user == null){
      userEmail = "Sign in";
      isLogin = false;
    }
  }


  Future<void> _signOut() async {
    await auth.signOut();
    await Firestore.terminate();
    await Firestore.clearPersistence();
    setState(() {
      isLogin = false;
      userEmail = "Sign in";
    });
  }

  Future<void>? dataFuture;
  List songList = [];
  String name = "";

  //Search
  TextEditingController _searchController = TextEditingController();
  _onSearchChange(){
    print(_searchController.text);
  }

  @override
  void didChangeDependencies(){
      super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    checkExisted();
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              color: AppColors.background,
              child: SafeArea(
                  child: Scaffold(
                body: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child:TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search)
                      ),
                      onChanged: (val){
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                    ),
                    // Container(
                    //     margin: const EdgeInsets.only(left: 20, right: 20),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         // Icon(Icons.menu, size: 24, color: Colors.black),
                    //         // Row(
                    //         //   children: [
                    //         //     SizedBox(
                    //         //       width: 10,
                    //         //     ),
                    //         //     InkWell(
                    //         //       onTap: _signOut,
                    //         //       child: Icon(Icons.exit_to_app),
                    //         //     ),
                    //         //     SizedBox(
                    //         //       width: 70,
                    //         //     ),
                    //         //     GestureDetector(
                    //         //       onTap: (){
                    //         //         if(isLogin == true){
                    //         //           print("User is currently logged in");
                    //         //         }
                    //         //         else if (isLogin == false){
                    //         //           Navigator.pushReplacementNamed(context, LoginPage.routeName);
                    //         //         }
                    //         //       },
                    //         //       child: Text("${userEmail}",
                    //         //         style: TextStyle(color: Colors.blue)
                    //         //         ,
                    //         //       ),
                    //         //     ),
                    //         //
                    //         //   ],
                    //         // )
                    //       ],
                    //     )),
                    Expanded(
                        child: ListView.builder(
                          itemCount: songList.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailAudioPage(
                                            songsData: songList, index: i)));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.tabVarViewColor,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(0, 0),
                                            color: Colors.grey.withOpacity(0.2),
                                          )
                                        ]),
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
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
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            size: 24,
                                                            color: AppColors
                                                                .starColor),
                                                        Text(
                                                          songList[i]["rating"],
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .menu2Color),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 130,
                                                      child: (
                                                          Text(
                                                            songList[i]["title"],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: "Avenir",
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          )
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      songList[i]["text"],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: "Avenir",
                                                          color: AppColors
                                                              .subTitleText),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    // Container(
                                                    //   width: 60,
                                                    //   height: 15,
                                                    //   decoration:
                                                    //   BoxDecoration(
                                                    //     borderRadius:
                                                    //     BorderRadius
                                                    //         .circular(
                                                    //         3),
                                                    //     color: AppColors
                                                    //         .loveColor,
                                                    //   ),
                                                    //   child: Text(
                                                    //     "Love",
                                                    //     style: TextStyle(
                                                    //         fontSize: 12,
                                                    //         fontFamily:
                                                    //         "Avenir",
                                                    //         color: Colors
                                                    //             .white),
                                                    //   ),
                                                    //   alignment: Alignment
                                                    //       .center,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            OutlinedButton(
                                                onPressed: () async {
                                                  final User? user =
                                                      auth.currentUser;
                                                  final uid = user?.uid;
                                                  var snapshot = await Firestore
                                                          .collection('user')
                                                      .doc(uid)
                                                      .collection('playlist')
                                                      .where("songID",
                                                          isEqualTo: songList[i]
                                                              ["songID"])
                                                      .get();
                                                  if (snapshot.docs.length ==
                                                      1) {
                                                    print(
                                                        "document is already exist");
                                                  } else {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('user')
                                                        .doc(uid)
                                                        .collection('playlist')
                                                        .doc()
                                                        .set({
                                                      "audio": songList[i]
                                                          ["audio"],
                                                      "rating": songList[i]
                                                          ["rating"],
                                                      "text": songList[i]
                                                          ["text"],
                                                      "img": songList[i]["img"],
                                                      "title": songList[i]
                                                          ["title"],
                                                      "songID": songList[i]
                                                          ["songID"],
                                                    });
                                                  }
                                                },
                                                child: Icon(Icons.add))
                                          ],
                                        ))),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )));
        });
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
                                InkWell(
                                  onTap: () {
                                    auth.signOut();
                                    Firestore.terminate();
                                    Firestore.clearPersistence();
                                    Navigator.of(context).pushReplacementNamed(
                                        LoginPage.routeName);
                                  },
                                  child: Icon(Icons.exit_to_app),
                                ),
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
                                // SliverAppBar(
                                //   pinned: true,
                                //   backgroundColor: AppColors.sliverBackground,
                                //   bottom: PreferredSize(
                                //     preferredSize: Size.fromHeight(50),
                                //     child: Container(
                                //       margin: const EdgeInsets.only(
                                //           bottom: 20, left: 20),
                                //       child: TabBar(
                                //         indicatorPadding:
                                //             const EdgeInsets.all(0),
                                //         indicatorSize:
                                //             TabBarIndicatorSize.label,
                                //         labelPadding:
                                //             const EdgeInsets.only(right: 10),
                                //         controller: _tabController,
                                //         isScrollable: true,
                                //         indicator: BoxDecoration(
                                //             borderRadius:
                                //                 BorderRadius.circular(25),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: Colors.grey
                                //                     .withOpacity(0.2),
                                //                 blurRadius: 7,
                                //                 offset: Offset(0, 0),
                                //               )
                                //             ]),
                                //         tabs: [
                                //           AppTabs(
                                //               color: AppColors.menu1Color,
                                //               text: "New"),
                                //           AppTabs(
                                //               color: AppColors.menu2Color,
                                //               text: "Popular"),
                                //           AppTabs(
                                //               color: AppColors.menu3Color,
                                //               text: "Treding"),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // )
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
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                '${songList[i]["img"]}'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
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
                                                            songList[i]["text"],
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
                                                          // Container(
                                                          //   width: 60,
                                                          //   height: 15,
                                                          //   decoration:
                                                          //   BoxDecoration(
                                                          //     borderRadius:
                                                          //     BorderRadius
                                                          //         .circular(
                                                          //         3),
                                                          //     color: AppColors
                                                          //         .loveColor,
                                                          //   ),
                                                          //   child: Text(
                                                          //     "Love",
                                                          //     style: TextStyle(
                                                          //         fontSize: 12,
                                                          //         fontFamily:
                                                          //         "Avenir",
                                                          //         color: Colors
                                                          //             .white),
                                                          //   ),
                                                          //   alignment: Alignment
                                                          //       .center,
                                                          // )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      OutlinedButton(
                                                          onPressed: () async {
                                                            final User? user =
                                                                auth.currentUser;
                                                            final uid =
                                                                user?.uid;
                                                            // var songTitle= songList[i]["title"];
                                                            // print(songTitle);
                                                            var snapshot = await Firestore
                                                                    .collection(
                                                                        'user')
                                                                .doc(uid)
                                                                .collection(
                                                                    'playlist')
                                                                .where("songID",
                                                                    isEqualTo:
                                                                        songList[i]
                                                                            [
                                                                            "songID"])
                                                                .get();
                                                            if (snapshot.docs
                                                                    .length ==
                                                                1) {
                                                              print(
                                                                  "document is already exist");
                                                            } else {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .doc(uid)
                                                                  .collection(
                                                                      'playlist')
                                                                  .doc()
                                                                  .set({
                                                                "audio":
                                                                    songList[i][
                                                                        "audio"],
                                                                "rating":
                                                                    songList[i][
                                                                        "rating"],
                                                                "text":
                                                                    songList[i][
                                                                        "text"],
                                                                "img":
                                                                    songList[i]
                                                                        ["img"],
                                                                "title":
                                                                    songList[i][
                                                                        "title"],
                                                                "songID":
                                                                    songList[i][
                                                                        "songID"],
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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String routeName = "/home_page";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    if(await FirebaseAuth.instance.currentUser == null){
      setState(() {
        _selectedIndex = index;
      });
    }
    else if (await FirebaseAuth.instance.currentUser != null){
      setState(() {
        _selectedIndex = index;
      });
    }

  }

  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    MyPlayListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'PlayList'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
