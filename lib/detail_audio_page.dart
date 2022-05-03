import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:online_music_player/audio_file.dart';
import 'app_colors.dart' as AppColors;

class DetailAudioPage extends StatefulWidget {
  const DetailAudioPage({Key? key, this.songsData, this.index})
      : super(key: key);
  static String routeName = "/detail_audio";
  final songsData;
  final int? index;

  @override
  _DetailAudioPageState createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  AudioPlayer? advancedPlayer;

  //Initialize audio player
  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    //khai bao bien tinh height va width cua mang hinh
    //giúp content resize trên các thiết bị khác
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.audioList,
      body: Stack(
        children: [
          //Top Background
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight / 4,
              child: Container(
                color: AppColors.headBackground,
              )),

          //AppBar
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: () {
                    advancedPlayer?.stop();
                    Navigator.of(context).pop();
                    },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {},
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              )),

          //Audio Player Box
          Positioned(
              left: 0,
              right: 0,
              top: screenHeight * 0.2,
              height: screenHeight * 0.36,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Text(this.widget.songsData[this.widget.index]["title"],
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Roboto")),
                      Text(this.widget.songsData[this.widget.index]["text"],
                        style: TextStyle(fontSize: 16),
                      ),
                      AudioFile(advancedPlayer: advancedPlayer,audioPath: this.widget.songsData[this.widget.index]["audio"]),
                    ],
                  ))),

          //Audio Image
          Positioned(
              top: screenHeight * 0.12,
              left: (screenWidth - 110) / 2,
              //Căn chỉnh lề trái phải để đưa về giữa
              right: (screenWidth - 110) / 2,
              height: screenHeight * 0.16,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(15), //padding all
                  child: Container(
                      decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                        image: AssetImage(this.widget.songsData[this.widget.index]["img"]),
                        fit: BoxFit.cover),
                  )),
                ),
              ))
        ],
      ),
    );
  }
}
