import 'package:flutter/material.dart';
import 'package:google_map_live/newgoto/screens/current_location_screen.dart';
import 'package:google_map_live/newgoto/screens/search_places_screen.dart';
import 'package:google_map_live/newgoto/screens/simple_map_screen.dart';


class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Google Maps"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const SimpleMapScreen();
              }));
            }, child: const Text("Simple Map")),

            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const CurrentLocationScreen();
              }));
            }, child: const Text("User current location")),

            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const SearchPlacesScreen();
              }));
            }, child: const Text("Search Places"))
          ],
        ),
      ),
    );
  }
}
