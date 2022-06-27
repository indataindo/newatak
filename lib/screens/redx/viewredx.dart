import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:custom_info_window/custom_info_window.dart';

class Viewredx extends StatefulWidget {
  const Viewredx({Key key}) : super(key: key);

  @override
  State<Viewredx> createState() => _ViewredxState();
}

class _ViewredxState extends State<Viewredx> {
  final LatLng _currentPosition =
      LatLng(-0.8971395757503112, 100.3507166778259);

  GoogleMapController mycontroller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specifi, specifyid) async {
    var markerIDval = specifyid;
    final MarkerId markerId = MarkerId(markerIDval);

    final Marker marker = Marker(
      markerId: markerId,
      infoWindow: InfoWindow(
        title: specifi['name'],
        snippet: specifi['no_wa'],
      ),
      position: LatLng(specifi['latitude'], specifi['longitude']),
    );

    if (isloading == true) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

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

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  List<Marker> list = [];

  getmarkerdarimysql() async {
    final response = await http.get(Uri.parse(RestApi.getredx));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/red_full.png",
      );

      for (int i = 0; i < data.length; i++) {
        var markerIDval = data[i]['id'].toString();
        var namalengkap = data[i]['nama_lengkap'];
        var lat = data[i]['latitude'];
        var long = data[i]['longitude'];
        var pesan = data[i]['pesan'];
        var tgl = data[i]['created_at'];

        final MarkerId markerId = MarkerId(markerIDval);

        final Marker marker = Marker(
            markerId: markerId,
/*
            infoWindow: InfoWindow(
              title: namalokasi,
              //snippet: event.docs[i]['no_wa'],
            ),
*/

            icon: markerbitmap,
            position: LatLng(double.parse(lat), double.parse(long)),
            onTap: () {
              _customInfoWindowController.addInfoWindow(
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.amber)),
                    child: Container(
                      height: 190,
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              namalengkap,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Pesan: "),
                            Text(pesan),
                            Row(
                              children: [
                                Text("Time : "),
                                Text(tgl),
                              ],
                            ),
                            RaisedButton(
                                onPressed: () {
                                  print("ini id casevac");
                                  _hapus(int.parse(markerIDval));
                                },
                                child: Icon(Icons.delete_forever_rounded)),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  LatLng(double.parse(lat), double.parse(long)));
            });
        setState(() {
          markers[markerId] = marker;
        });
      }
    }
  }

  _hapus(int id) async {
    final response = await http.post(Uri.parse(RestApi.deleteredx), body: {
      "id": id.toString(),
    });
    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'];
    if (value == "1") {
      pesan();
    } else {
      print("Data gagal");
    }
  }

  Future<void> pesan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Delete Success',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
                getmarkerdarimysql();
                //   getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmarkerdarimysql();
    getLocation();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
  }

  bool isloading = false;
  int ty = 0;
  var maptype = MapType.normal;

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
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: maptype,
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    // _controller.complete(controller);
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: currentPostion,
                    zoom: 16.0,
                  ),
                  onTap: (postition) {
                    _customInfoWindowController.hideInfoWindow();
                  },
                  onCameraMove: (postition) {
                    _customInfoWindowController.onCameraMove();
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 200,
                  width: 300,
                  offset: 35,
                )
              ],
            ),
    );
  }
}
