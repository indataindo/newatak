import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/core/models/modelpolygon.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/adduser.dart';
import 'package:google_map_live/screens/area.dart';
import 'package:google_map_live/ui/screen/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;

class Alluser extends StatefulWidget {
  const Alluser({Key key}) : super(key: key);

  @override
  State<Alluser> createState() => _AlluserState();
}

class _AlluserState extends State<Alluser> {
  LatLng currentPostion;
  Location _location = Location();
  final loc.Location location = loc.Location();

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  //data area
  var loading = false;
  final listarea = new List<Modepolygon>();

  tampil() async {
    listarea.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(RestApi.getpolygon));
    if (response.contentLength == 2) {
    } else {
      final datapromo = jsonDecode(response.body);
      datapromo.forEach((api) {
        final p = new Modepolygon(api['id'], api['title']);
        listarea.add(p);
      });

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    tampil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location_alt),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: listarea.length,
                  itemBuilder: (context, i) {
                    final data = listarea[i];
                    return ListTile(
                      enabled: true,
                      tileColor: Colors.blue,
                      title: Row(
                        children: [
                          Text(
                            "Nama Area :",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            data.title,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      subtitle: Text(data.id.toString()),
                    );
                  },
                ),
        ));
  }
}
