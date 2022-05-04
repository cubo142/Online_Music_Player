import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/login/login_page.dart';
import 'package:online_music_player/Services/AuthenticationService.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static String routeName = "/signup";
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MSPlay",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            Text("SignUp",
                style: TextStyle(color: Colors.black, fontSize: 44.0)),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value == null) {
                  return 'Email cannot be empty';
                } else
                  return null;
              },
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.mail, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null) {
                  return 'password cannot be empty';
                } else
                  return null;
              },
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.key, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Don't remember password ?",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () async {
                  User? user =
                      await AuthenticationServices.SignUpWithEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
                  if (user != null) {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginPage.routeName);
                  }
                },
                fillColor: Color(0xFF2196F3),
                elevation: 0.0,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Sign Up",
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
                    Navigator.of(context).pushNamed(LoginPage.routeName);
                  },
                  child: Text(
                    "Have an account?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
