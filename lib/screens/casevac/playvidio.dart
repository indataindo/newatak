import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Playvidio extends StatefulWidget {
  final String vidio;
  const Playvidio({Key key, this.vidio}) : super(key: key);

  @override
  State<Playvidio> createState() => _PlayvidioState();
}

class _PlayvidioState extends State<Playvidio> {


   TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     initializePlayer();
  }
@override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }


Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network('http://8.215.39.14/amarta/public/upload/event/'+widget.vidio);
    await _videoPlayerController1.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: new AppBar(
         
            leading: new IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, boxShadow: []),
                child: new Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            title: Text(widget.vidio,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Kali',
                  color: Colors.white,
                ))),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading',style: TextStyle(fontFamily: 'Kali'),),
                        ],
                      ),
              ),
            ),
            FlatButton(
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: const Text('Fullscreen',style: TextStyle(fontFamily: 'Kali'),),
            ),
          ],
        )
    );
  }
}
