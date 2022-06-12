import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

var Firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

String? userEmail;
bool? isLogin;

class _ProfilePageState extends State<ProfilePage> {

  Future<void> _signOut() async {
    await auth.signOut();
    await Firestore.terminate();
    await Firestore.clearPersistence();
    setState(() {
      isLogin = false;
      userEmail = "Sign in";
    });
  }

  Future<void> getData() async {
    // QuerySnapshot querySnapshot = await Firestore.collection('songs').get();
    // songList = querySnapshot.docs.map((doc) => doc.data()).toList();
    final user = await auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user?.email;
        isLogin = true;
      });
    } else if (user == null) {
      userEmail = "Sign in";
      isLogin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(user == null){
            return Container(
              child: Column(
                children: [
                  SizedBox(height:250),
                  Text("Your are not logged in"),
                  SizedBox(height: 10,),
                  GestureDetector(
                    child: Text("Sign in", style: TextStyle(fontSize: 16,color: Colors.blue),),
                    onTap: (){
                      Navigator.pushReplacementNamed(context,LoginPage.routeName);
                    },
                  ),
                ],
              ),
            );
          }
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 130,
                  width: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                            "https://baokhanhhoa.vn/dataimages/201909/original/images5376527_4.jpg"),
                        backgroundColor: Colors.transparent,
                      ),
                      Positioned(
                          bottom: -5,
                          right: -7,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.camera_alt_rounded),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (isLogin == true) {
                      print("User is currently logged in");
                    } else if (isLogin == false) {
                      print("none");
                    }
                  },
                  child: Text(
                    "${userEmail}",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: FlatButton(
                  onPressed: (){},
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Color(0xF295502),
                  child: Row(
                    children: [
                      Icon(Icons.lock,color: Colors.orange,),
                      SizedBox(width: 20),
                      Expanded(child: Text("Change password",
                      style:Theme.of(context).textTheme.bodyText1),)
                    ],
                  ),

                ),),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: FlatButton(
                    onPressed: _signOut,
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Color(0xF295502),
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app,color: Colors.orange,),
                        SizedBox(width: 20),
                        Expanded(child: Text("Sign out",
                            style:Theme.of(context).textTheme.bodyText1),)
                      ],
                    ),

                  ),)
              ],
            ),
          );
        });
  }
}
