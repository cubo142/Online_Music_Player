import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_music_player/login/login_page.dart';
import 'app_colors.dart' as AppColors;
import 'detail_audio_page.dart';

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
Future<void>? dataFuture;

// Future<List> getPlayList() async {
//   QuerySnapshot querySnapshot =
//       await Firestore.collection('user').doc(uid).collection('playlist').get();
//   songPlayList = querySnapshot.docs.map((doc) => doc.data()).toList();
//   return songPlayList;
// }

void checkAccount(BuildContext context) {
  if (user == null) {
    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }
} //check playlist, sau khi chuyển ra ko đăng nhập vào lại đc :))

Future<void> getPlayList() async {
  QuerySnapshot querySnapshot =
      await Firestore.collection('user').doc(uid).collection('playlist').get();
  songPlayList = querySnapshot.docs.map((doc) => doc.data()).toList();
}

class _MyPlayListPageState extends State<MyPlayListPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPlayList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return Text(snapshot.data);
          }
          return ListView.builder(
              itemCount: songPlayList.length,
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailAudioPage(
                                    songsData: songPlayList,
                                    index: i)));
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
                                              '${songPlayList[i]["img"]}'),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                size: 24,
                                                color: AppColors.starColor),
                                            Text(
                                              songPlayList[i]["rating"],
                                              style: TextStyle(
                                                  color: AppColors.menu2Color),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                            songPlayList[i]["title"],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Avenir",
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          songPlayList[i]["text"],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Avenir",
                                              color: AppColors.subTitleText),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // Container(
                                        //   width: 60,
                                        //   height: 15,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(3),
                                        //     color: AppColors.loveColor,
                                        //   ),
                                        //   child: Text(
                                        //     "Love",
                                        //     style: TextStyle(
                                        //         fontSize: 12,
                                        //         fontFamily: "Avenir",
                                        //         color: Colors.white),
                                        //   ),
                                        //   alignment: Alignment.center,
                                        // )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),

                                  ],
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      var snapshot =
                                      await Firestore.collection('user')
                                          .doc(uid)
                                          .collection('playlist')
                                          .where("songID",
                                          isEqualTo: songPlayList[i]
                                          ["songID"])
                                          .get();
                                      // var querySnapshots = await collection;
                                      var doc = snapshot.docs[0];
                                      doc.reference.delete();
                                      setState(() {});
                                    },
                                    child: Icon(Icons.delete))
                              ],
                            )
                           )),
                  ),
                );
              });
        });

    return StreamBuilder(
        stream: Firestore.collection('user')
            .doc(uid)
            .collection('playlist')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                              children: [
                                Container(
                                  height: 70,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          '${songPlayList[i]["img"]}'),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            size: 24,
                                            color: AppColors.starColor),
                                        Text(
                                          songPlayList[i]["rating"],
                                          style: TextStyle(
                                              color: AppColors.menu2Color),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      songPlayList[i]["title"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Avenir",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      songPlayList[i]["text"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Avenir",
                                          color: AppColors.subTitleText),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Container(
                                    //   width: 60,
                                    //   height: 15,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(3),
                                    //     color: AppColors.loveColor,
                                    //   ),
                                    //   child: Text(
                                    //     "Love",
                                    //     style: TextStyle(
                                    //         fontSize: 12,
                                    //         fontFamily: "Avenir",
                                    //         color: Colors.white),
                                    //   ),
                                    //   alignment: Alignment.center,
                                    // )
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      var snapshot =
                                          await Firestore.collection('user')
                                              .doc(uid)
                                              .collection('playlist')
                                              .where("songID",
                                                  isEqualTo: songPlayList[i]
                                                      ["songID"])
                                              .get();
                                      // var querySnapshots = await collection;
                                      var doc = snapshot.docs[0];
                                      doc.reference.delete();
                                      setState(() {});
                                    },
                                    child: Icon(Icons.delete))
                              ],
                            ))),
                  ),
                );
              });
        });
  }
}
