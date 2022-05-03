import 'package:flutter/material.dart';
import 'package:online_music_player/my_home_page.dart';
import 'package:online_music_player/routes.dart';
import 'detail_audio_page.dart';
import 'package:flutter/services.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: MyHomePage.routeName,
        routes: route,
    );
  }
}
