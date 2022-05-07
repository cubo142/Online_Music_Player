import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';


class AudioFile extends StatefulWidget {
  final AudioPlayer? advancedPlayer;
  final String? audioPath;

  const AudioFile({Key? key, this.advancedPlayer,this.audioPath}) : super(key: key);

  @override
  State<AudioFile> createState() => _AudioFileState();


}



class _AudioFileState extends State<AudioFile> {

  //Track track thời lượng audio
  Duration _duration = new Duration();

  //Track audio đã play tới đâu
  Duration _position = new Duration();


  //trạng thái các nút trên audio player
  double playBackRate = 1.0;
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;
  bool isRepeat = false;
  Color color = Colors.black;

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
    this.widget.advancedPlayer?.setUrl(this.widget.audioPath as String);
    this.widget.advancedPlayer?.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        if (isRepeat == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeat = false;
        }
      });
    });
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
              Text(_position.toString().split(".")[0],
                  style: TextStyle(fontSize: 16)),
              Text(_duration.toString().split(".")[0],
                  style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        slider(),
        loadAsset(),
      ],
    ));
  }

  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 10),
      icon: isPlaying == false
          ? Icon(_icons[0], size: 40)
          : Icon(
              _icons[1],
              size: 40,
            ),
      onPressed: () async {
        if (isPlaying == false) {

          this.widget.advancedPlayer?.play(this.widget.audioPath as String);
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
          btnRepeat(),
          btnSlow(),
          btnStart(),
          btnFast(),
          btnLoop(),
        ],
      ),
    );
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        });
  }

  //Hàm tương tác với slider
  void changeToSecond(int second) {
    //giá trị value được truyền vào hàm sẽ lưu vào second
    Duration newDuration = Duration(seconds: second);
    this.widget.advancedPlayer?.seek(newDuration);
    //Cách hoạt động:
    //1. truyền value vào second dc định nghĩa của hàm khởi tạo
    //2. Khai báo 1 constructor Duration nhận vào second
    //3.sử dụng seek để lấy value Duration (aka slider)
  }

  Widget btnFast() {
    return IconButton(
      icon: Icon(Icons.fast_forward, size: 20),
      color: Colors.black,
      onPressed: () {
        if (playBackRate > 0.25 && playBackRate < 2.5) {
          playBackRate += 0.25;
          this.widget.advancedPlayer?.setPlaybackRate(playBackRate);
          showPlayBackRate();
        } else if (playBackRate == 0.25) {
          playBackRate += 0.25;
          this.widget.advancedPlayer?.setPlaybackRate(playBackRate);
          showPlayBackRate();
        }
      },
    );
  }

  Widget btnSlow() {
    return Transform.scale(
        scaleX: -1,
        child: IconButton(
          icon: Icon(Icons.fast_forward, size: 20),
          color: Colors.black,
          onPressed: () {
            if (playBackRate > 0.25 && playBackRate <= 2.5) {
              playBackRate -= 0.25;
              this.widget.advancedPlayer?.setPlaybackRate(playBackRate);
              showPlayBackRate();
            } else if (playBackRate == 2.5) {
              playBackRate -= 0.25;
              this.widget.advancedPlayer?.setPlaybackRate(playBackRate);
              showPlayBackRate();
            }
          },
        ));
  }

  //cân nhắc 1 chức năng nào đó
  Widget btnLoop() {
    return IconButton(
      icon: Icon(Icons.loop, size: 0),
      color: Colors.black,
      onPressed: () {},
    );
  }

  Widget btnRepeat() {
    return IconButton(
      icon: Icon(Icons.repeat, size: 20),
      color: color,
      onPressed: () {
        if (isRepeat == false) {
          this.widget.advancedPlayer?.setReleaseMode(ReleaseMode.LOOP);
          setState(() {
            isRepeat = true;
            color = Colors.blue;
          });
        } else if (isRepeat == true) {
          this.widget.advancedPlayer?.setReleaseMode(ReleaseMode.RELEASE);
          setState(() {
            isRepeat = false;
            color = Colors.black;
          });
        }
      },
    );
  }

  void showPlayBackRate() {
    Fluttertoast.showToast(
        msg: "Music speed: ${playBackRate.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }
}
