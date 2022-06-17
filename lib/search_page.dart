import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/my_playlist_page.dart';
import 'app_colors.dart' as AppColors;
import 'detail_audio_page.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  static String routeName = "/search";

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = "";
  List songList = [];

  Future<void> getData() async {
    QuerySnapshot qr = await Firestore.collection('songs')
        .where('title', isGreaterThanOrEqualTo: name)
        .get();
    songList = qr.docs.map((doc) => doc.data()).toList();
  }

  //Search
  TextEditingController _searchController = TextEditingController();

  _onSearchChange() {
    print(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Search Song'),
            ),
            body: Container(
                child: SafeArea(
                    child: Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: TextField(
                      decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
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
                                      BorderRadius.circular(
                                          10),
                                      color: AppColors
                                          .tabVarViewColor,
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
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
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
                                                    fit: BoxFit
                                                        .fill,
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
                                                      Icon(
                                                          Icons
                                                              .star,
                                                          size:
                                                          24,
                                                          color: AppColors
                                                              .starColor),
                                                      Text(
                                                        songList[
                                                        i]
                                                        [
                                                        "rating"],
                                                        style: TextStyle(
                                                            color:
                                                            AppColors.menu2Color),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 130,
                                                    child: (Text(
                                                      songList[i][
                                                      "title"],
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontSize:
                                                          16,
                                                          fontFamily:
                                                          "Avenir",
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    songList[i]
                                                    ["text"],
                                                    style: TextStyle(
                                                        fontSize:
                                                        16,
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
                                                          .circular(3),
                                                      color: AppColors
                                                          .loveColor,
                                                    ),
                                                    child: Text(
                                                      songList[i][
                                                      "category"],
                                                      style: TextStyle(
                                                          fontSize:
                                                          12,
                                                          fontFamily:
                                                          "Avenir",
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    alignment:
                                                    Alignment
                                                        .center,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ))),
          );
        });
  }
}
