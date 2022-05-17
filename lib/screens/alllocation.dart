import 'package:flutter/material.dart';


class Alllocation extends StatefulWidget {
  const Alllocation({ Key key }) : super(key: key);

  @override
  State<Alllocation> createState() => _AlllocationState();
}

class _AlllocationState extends State<Alllocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text("All Location"),
      )
    );
  }
}