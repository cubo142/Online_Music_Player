import 'package:flutter/cupertino.dart';
import 'package:online_music_player/detail_audio_page.dart';
import 'package:online_music_player/login/login_page.dart';
import 'package:online_music_player/my_home_page.dart';
import 'package:online_music_player/signup/signup.dart';

final Map<String, WidgetBuilder> route = {
  DetailAudioPage.routeName: (context) => DetailAudioPage(),
  MyHomePage.routeName: (context) => MyHomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  SignUpPage.routeName:(context) => SignUpPage(),
};