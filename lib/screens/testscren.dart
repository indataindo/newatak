import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Chetscreen(
                  id:  event.docs[i]['userid'],
                  nama: event.docs[i]['name'],
                )));
           
          },
          markerId: markerId,
          infoWindow: InfoWindow(
            title: event.docs[i]['name'],
            snippet: event.docs[i]['no_wa'],
          ),
          position:
              LatLng(event.docs[i]['latitude'], event.docs[i]['longitude']),
        );
        setState(() {
          markers[markerId] = marker;
        });

        //   initMarker(snapshot.data.docs[i].data(), snapshot.data.docs[i].id);

      }
    });

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

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPostion == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.hybrid,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: currentPostion,
                zoom: 16.0,
              )),
    );
  }
}
