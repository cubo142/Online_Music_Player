import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference songsList =
      FirebaseFirestore.instance.collection('songs');


  Future getSongsList() async {
    List itemList=[];
    try {
      await songsList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((e) {
          itemList.add(e.data);
        });
      });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
