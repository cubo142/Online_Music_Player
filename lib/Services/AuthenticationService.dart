import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_music_player/my_playlist_page.dart';

import '../model/songs.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference playListCollection =
      FirebaseFirestore.instance.collection('user');
  final String? uid;

  AuthenticationServices({this.uid});

  Future updateUserData(String title) async {
    return await playListCollection.doc(uid).set({
      'title':title
    });
  }



  //Sign In
  static Future<User?> SignInWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("Email does not exist");
      }
    }
    return user;
  }

  //Sign Up

  static Future<User?> SignUpWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    await AuthenticationServices(uid: user?.uid).updateUserData('title');
    return user;
  }

  //Sign Out not complete
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
