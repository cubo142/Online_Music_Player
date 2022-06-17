import 'package:flutter/cupertino.dart';
import 'package:online_music_player/change_password_page.dart';

import 'package:online_music_player/detail_audio_page.dart';
import 'package:online_music_player/login/login_page.dart';
import 'package:online_music_player/my_home_page.dart';
import 'package:online_music_player/my_playlist_page.dart';
import 'package:online_music_player/profile_page.dart';
import 'package:online_music_player/reset_password_page.dart';
import 'package:online_music_player/search_page.dart';
import 'package:online_music_player/signup/signup.dart';

final Map<String, WidgetBuilder> route = {
  DetailAudioPage.routeName: (context) => DetailAudioPage(),
  MyHomePage.routeName: (context) => MyHomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  MyPlayListPage.routeName: (context) => MyPlayListPage(),
  SignUpPage.routeName: (context) => SignUpPage(),
  Home.routeName: (context) => Home(),
  ProfilePage.routeName: (context) => ProfilePage(),
  ResetPassword.routeName: (context) => ResetPassword(),
  ChangePassword.routeName: (context) => ChangePassword(),
  Search.routeName: (context) => Search(),
};
