import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/login/components/body.dart';
import 'package:online_music_player/login/components/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String routeName = "/login";

  @override
  Widget build(BuildContext context) => Scaffold(
    body: LoginForm(),
  );
}
