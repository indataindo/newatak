import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

class Testscreen extends StatefulWidget {
  const Testscreen({Key key}) : super(key: key);

  @override
  State<Testscreen> createState() => _TestscreenState();
}

class _TestscreenState extends State<Testscreen> {
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

  getmarkerdata() async {
    await FirebaseFirestore.instance
        .collection('location')
        .where('online', isEqualTo: 1)
        .snapshots()
        .listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        var markerIDval = event.docs[i].id;
        final MarkerId markerId = MarkerId(markerIDval);

        final Marker marker = Marker(
          onTap: () {
            print("ini lokasi");
            _customInfoWindowController.addInfoWindow(
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        event.docs[i]['name'],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      RaisedButton(
                          child: Text("Chating"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chetscreen(
                                          id: event.docs[i]['userid'],
                                          nama: event.docs[i]['name'],
                                        )));
                          })
                    ],
                  )),
                ),
                LatLng(event.docs[i]['latitude'], event.docs[i]['longitude']));
/*
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chetscreen(
                          id: event.docs[i]['userid'],
                          nama: event.docs[i]['name'],
                        )));
*/
          },
          markerId: markerId,
          /*
          infoWindow: InfoWindow(
            title: event.docs[i]['name'],
            snippet: event.docs[i]['no_wa'],
          ),
          */
          position:
              LatLng(event.docs[i]['latitude'], event.docs[i]['longitude']),
        );
        setState(() {
          markers[markerId] = marker;
        });

        //   initMarker(snapshot.data.docs[i].data(), snapshot.data.docs[i].id);

      }
    });

    _pesan() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);

                          // Fluttertoast.showToast(msg: " Add Red X");
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          child: Center(child: Text("Add")),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          child: Center(child: Text("View")),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('location')
            .where('online', isEqualTo: 1)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              var someData = snapshot.data.docs;
              print(someData);
            }
          }
          return Text("da");
        });
  }

  Marker marker1 = Marker(
    markerId: MarkerId('Marker1'),
    position: LatLng(32.195476, 74.2023563),
    infoWindow: InfoWindow(title: 'Business 1'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );
  Marker marker2 = Marker(
    markerId: MarkerId('Marker2'),
    position: LatLng(31.110484, 72.384598),
    infoWindow: InfoWindow(title: 'Business 2'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );

  List<Marker> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = [marker1, marker2];
    print(list);
    getmarkerdata();
    getLocation();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
  }

  int ty = 0;
  var maptype = MapType.normal;
  bool isloading = false;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
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
          : Stack(children: [
              GoogleMap(
                mapType: maptype,
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _customInfoWindowController.googleMapController = controller;
                  // _controller.complete(controller);
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
            ]),
    );
  }
}
