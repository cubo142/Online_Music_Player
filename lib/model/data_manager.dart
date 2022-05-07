// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class DataManager extends StatefulWidget {
//   static String routeName = "/test";
//   const DataManager({Key? key}) : super(key: key);
//
//   @override
//   State<DataManager> createState() => _DataManagerState();
// }
//
// class _DataManagerState extends State<DataManager> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('songs')
//               .snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
//             return ListView(
//               children: snapshot.data!.docs.map((song){
//                 return Center(
//                   child: ListTile(
//                     title: Text(song['title'])
//                   ),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
