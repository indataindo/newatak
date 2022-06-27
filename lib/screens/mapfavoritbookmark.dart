import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/core/models/locasimodel.dart';
import 'package:google_map_live/core/models/location_model.dart';
import 'package:google_map_live/core/models/modelpolygonfavorit.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

class Mapfavoritbookmark extends StatefulWidget {
  final int idpolygon;

  const Mapfavoritbookmark({Key key, this.idpolygon}) : super(key: key);

  @override
  State<Mapfavoritbookmark> createState() => _MapfavoritbookmarkState();
}

class _MapfavoritbookmarkState extends State<Mapfavoritbookmark> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  Completer<GoogleMapController> _controller = Completer();
  //data area
  var loading = false;
  final listarea = new List<Lokasimodel>();
  Set<Polygon> _polygon = HashSet<Polygon>();
  List<LatLng> point = [
    /*
    LatLng(37.43296265331129, -122.08832357078792),
    LatLng(37.43006265331129, -122.08832357078792),
    LatLng(37.43006265331129, -122.08332357078792),
    LatLng(37.43296265331129, -122.08832357078792),
    */
  ];

  tampil() async {
    listarea.clear();
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.getlatlang), body: {
      "idpolygon": widget.idpolygon.toString(),
    });
    if (response.contentLength == 2) {
    } else {
      final datapromo = jsonDecode(response.body);

      datapromo.forEach((api) {
        point.add(LatLng(
            double.parse(api['latitude']), double.parse(api['longitude'])));
      });
      _polygon.add(Polygon(
          polygonId: PolygonId('1'),
          points: point,
          fillColor: Colors.red.withOpacity(0.1),
          strokeColor: Colors.red,
          strokeWidth: 1,
          geodesic: true));
      setState(() {
        loading = false;
      });
    }
  }

  LatLng currentPostion;
  Location _location = Location();

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  int ty = 0;
  var maptype = MapType.normal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    tampil();
/*
  
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.black,
        child: const Icon(Icons.map_outlined),
        onPressed: () {
          setState(() {
            if (maptype == MapType.normal) {
              this.maptype = MapType.hybrid;
            } else {
              this.maptype = MapType.normal;
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: currentPostion == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              polygons: _polygon,
              mapType: maptype,
              initialCameraPosition:
                  CameraPosition(zoom: 15, target: currentPostion),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
