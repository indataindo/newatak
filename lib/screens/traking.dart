import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class Tracking extends StatefulWidget {
  const Tracking({Key key}) : super(key: key);

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  int isLoading = 0;
  GoogleMapController mycontroller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _currentPosition =
      LatLng(-0.8971395757503112, 100.3507166778259);

  initMarker(specifi, specifyid) async {
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

    setState(() {
      markers[markerId] = marker;
    });
  }

  getmarkerdata() async {
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

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;

  LatLng currentPostion;
  Location _location = Location();

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> collectionstream =
      FirebaseFirestore.instance
          .collection('location')
          .where('online', isEqualTo: 1)
          .snapshots();

  bool _loadingjek = false;
  @override
  void initState() {
    // getmarkerdata();
    // TODO: implement initState
    super.initState();

    getLocation();

    // _requestpermision();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    //location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
/*
    Set<Marker> getmarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId("go"),
            position: _currentPosition,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "belajar"))
      ].toSet();
    }
*/
    return Scaffold(
        body: currentPostion == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: collectionstream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      initMarker(snapshot.data.docs[i].data(),
                          snapshot.data.docs[i].id);
                    }

                    return GoogleMap(
                        // polygons: myPolygon(),
                        markers: Set<Marker>.of(markers.values),
                        onMapCreated: (GoogleMapController controller) {
                          mycontroller = controller;
                        },
                        mapType: MapType.hybrid,
                        myLocationEnabled: true,
                        initialCameraPosition:
                            CameraPosition(target: currentPostion, zoom: 14.5));
                  }
                }),
                
        /*
      body: GoogleMap(
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            mycontroller = controller;
          },
          initialCameraPosition:
              CameraPosition(target: _currentPosition, zoom: 15)),

*/
        );
  }
}
