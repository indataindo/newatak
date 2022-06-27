import 'package:flutter/material.dart';

class Zoomimage extends StatefulWidget {
  final String image;

  const Zoomimage({Key key, this.image}) : super(key: key);

  @override
  State<Zoomimage> createState() => _ZoomimageState();
}

class _ZoomimageState extends State<Zoomimage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network('http://8.215.39.14/amarta/public/upload/event/' +widget.image,fit: BoxFit.cover,)),
      
    );
  }
}
