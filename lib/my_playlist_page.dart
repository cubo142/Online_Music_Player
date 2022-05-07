import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/detail_audio_page.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/songs.dart';
import 'app_colors.dart' as AppColors;

class MyPlayListPage extends StatefulWidget {
  const MyPlayListPage({Key? key}) : super(key: key);
  static const routeName = '/myplaylist';



  @override
  State<MyPlayListPage> createState() => _MyPlayListPageState();
}

List songPlayList = [];
var Firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

final User? user = auth.currentUser;
final uid = user?.uid;


Future<List> getPlayList() async {
  QuerySnapshot querySnapshot = await Firestore.collection('playlist').doc(uid).collection('songs').get();
  songPlayList = querySnapshot.docs.map((doc) => doc.data()).toList();
  for(int i = 0; i<songPlayList.length;i++){
    for(int j=0;j<songPlayList.length;j++){
      if(songPlayList[i]["songID"] == songPlayList[j]["songID"]){
        songPlayList.removeAt(j);
      }
    }
  }

  return songPlayList;
}


class _MyPlayListPageState extends State<MyPlayListPage> {
  @override
  Widget build(BuildContext context) {
    getPlayList();
    print(songPlayList.length);
    return ListView.builder(
        itemCount: songPlayList.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             DetailAudioPage(
              //                 songsData: songList,
              //                 index: i)));
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
                                image: NetworkImage('${songPlayList[i]["img"]}'),
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
                                    songPlayList[i]
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
                                songPlayList[i]
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
                                songPlayList[i]
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
                                await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                  await myTransaction.delete(songPlayList[i].reference);
                                });
                              },
                              child:
                              Icon(Icons.delete))
                        ],
                      ))),
            ),
          );
        });
  }
}

