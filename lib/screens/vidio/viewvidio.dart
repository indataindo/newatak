import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/casevac/playvidio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:custom_info_window/custom_info_window.dart';

class Viewvidio extends StatefulWidget {
  const Viewvidio({Key key}) : super(key: key);

  @override
  State<Viewvidio> createState() => _ViewvidioState();
}

class _ViewvidioState extends State<Viewvidio> {
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
    final response = await http.get(Uri.parse(RestApi.getvidio));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        var markerIDval = data[i]['id'].toString();
        var namalokasi = data[i]['namalokasi'];
        var lat = data[i]['latitude'];
        var long = data[i]['longitude'];
        var vidio = data[i]['vidio'];
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

            //  icon: markerbitmap,
            position: LatLng(double.parse(lat), double.parse(long)),
            onTap: () {
              _customInfoWindowController.addInfoWindow(
                  Stack(children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.amber)),
                      child: Container(
                        width: 300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                namalokasi,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("vidio: "),
                              vidio == null
                                  ? Text("No Vido")
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Playvidio(
                                                      vidio: vidio,
                                                    )));
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.play_arrow_sharp,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                              // Text(vidio == null ? "Tidak ada vidio" : vidio),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 20,
                        width: double.infinity,
                        color: Colors.amber,
                        child: Row(
                          children: [
                            Text("Posted : "),
                            Text(tgl),
                          ],
                        ),
                      ),
                    )
                  ]),
                  LatLng(double.parse(lat), double.parse(long)));
            });
        setState(() {
          markers[markerId] = marker;
        });
      }
    }
  }

  int ty = 0;
  var maptype = MapType.normal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmarkerdarimysql();
    getLocation();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Vidio Streaming"),
      ),
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
                  height: 150,
                  width: 300,
                  offset: 35,
                )
              ],
            ),
    );
  }
}
