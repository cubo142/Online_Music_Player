import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_music_player/my_home_page.dart';
import 'package:online_music_player/signup/signup.dart';
import 'package:online_music_player/Services/AuthenticationService.dart';

import '../../reset_password_page.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //Initialize Firebase
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return MyHomePage();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return LoginForm();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    //Textfield Controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pushReplacementNamed(context, Home.routeName);
              },
            ),
          ),
          Text(
            "MSPlay",
            style: TextStyle(
                color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
          ),
          Text("Login", style: TextStyle(color: Colors.black, fontSize: 44.0)),
          SizedBox(height: 10),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.key, color: Colors.black),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ResetPassword.routeName);
            },
            child: Text(
              "Don't remember password ?",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () async {
                User? user =
                    await AuthenticationServices.SignInWithEmailPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        context: context);
                print(user);
                if (user != null) {
                  Navigator.of(context).pushReplacementNamed(Home.routeName);
                } else {
                  Fluttertoast.showToast(msg: "Username or Password wrong!");
                }
              },
              fillColor: Color(0xFF2196F3),
              elevation: 0.0,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("SIGN IN",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(SignUpPage.routeName);
                },
                child: Text(
                  "Don't have an account? Create",
                  style: TextStyle(color: Colors.blue),
                ),
              ))
        ],
      ),
    );
  }
}
