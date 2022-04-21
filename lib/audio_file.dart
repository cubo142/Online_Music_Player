import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer? advancedPlayer;

  const AudioFile({Key? key, this.advancedPlayer}) : super(key: key);

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  //Track track thời lượng audio
  Duration _duration = new Duration();
  //Track audio đã play tới đâu
  Duration _position = new Duration();

  final String path = 'https://tainhacmienphi.biz/get/song/api/8708';
  //trạng thái các nút trên audio player
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;
  List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  @override
  void initState() {
    super.initState();
    this.widget.advancedPlayer?.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    this.widget.advancedPlayer?.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });
    this.widget.advancedPlayer?.setUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_position.toString().split(".")[0], style: TextStyle(fontSize: 16)),
              Text(_duration.toString().split(".")[0], style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        loadAsset(),
      ],
    ));
  }

  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 10),
      icon: isPlaying == false ? Icon(_icons[0],size:50) : Icon(_icons[1],size: 50,),
      onPressed: () {
        if (isPlaying == false) {
          this.widget.advancedPlayer?.play(path);
          setState(() {
            isPlaying = true;
          });
        } else if (isPlaying == true) {
          setState(() {
            this.widget.advancedPlayer?.pause();
            isPlaying = false;
          });
        }
      },
    );
  }

  Widget loadAsset() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          btnStart(),
        ],
      ),
    );
  }
}
