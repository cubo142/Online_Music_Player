import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.headBackground,
      child: Scaffold(
          body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left:10,right:10),
              child:
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu),
              Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Icon(Icons.notifications)
                ],
              )
            ],
          ))
        ],
      )),
    );
  }
}
