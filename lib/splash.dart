import 'package:flutter/material.dart';
import 'package:google_map_live/onboarding.dart';


class Spash extends StatefulWidget {
  const Spash({Key key}) : super(key: key);

  @override
  _SpashState createState() => _SpashState();
}

class _SpashState extends State<Spash> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  int _current = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween<double>(begin: 0, end: 2).animate(controller)
      ..addListener(() {
        setState(() {
          controller.forward();
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OnBoardingPage()));
        } else {
          controller?.forward();
        }
      });

    controller?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                //  SizedBox(child: Image.asset('assets/Logos-01.png')),
                ],
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
