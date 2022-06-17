import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_music_player/my_home_page.dart';
import 'package:online_music_player/profile_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  static String routeName = "/changepassword";

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final newPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPassController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  Future resetPassword() async {
    try {
      await currentUser!.updatePassword(newPassController.text.trim());
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Insert your new password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: newPassController,
                cursorColor: Colors.white,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: resetPassword,
                icon: Icon(Icons.key),
                label: Text(
                  'Change password',
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
