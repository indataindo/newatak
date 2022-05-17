import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_map_live/contohmulti/multi.dart';
import 'package:google_map_live/map.dart';
import 'package:google_map_live/screens/traking.dart';
import 'package:google_map_live/utils/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;
  String nama_lengkap1 = "";
  String nama_lengkap = "";
  String no_wa = "";
  String no_wa1 = "";

  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();
    nama_lengkap = preferences.getString("nama_lengkap").toString();
    no_wa = preferences.getString("no_wa").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      nama_lengkap1 = nama_lengkap;
      no_wa1 = no_wa;
    });
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

  Set<Polygon> myPolygon() {
    //List<LatLng> polygonCoords = new List();
    var polygonCoords = new List<LatLng>();

    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08332357078792));
    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));

    //Set<Polygon> polygonSet = new Set();

    var polygonSet = Set<Polygon>();

    polygonSet.add(Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,
        strokeColor: Colors.red));

    return polygonSet;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
    getLocation();

    _requestpermision();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  GoogleMapController mycontroller;
  static CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(-0.8971395757503112, 100.3507166778259), zoom: 14);
  Set<Marker> marke = {};

  void _onMapCreatedd(GoogleMapController controller) {
    mycontroller = controller;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference location = firestore.collection('location');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          currentPostion == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  polygons: myPolygon(),
                  initialCameraPosition:
                      CameraPosition(target: currentPostion, zoom: 15),
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    //    mycontroller = controller;
                  },
                  myLocationEnabled: true,
                  markers: {
                      Marker(
                          markerId: MarkerId('id'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueMagenta),
                          position: currentPostion)
                    }),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(-5, 0),
                      blurRadius: 15,
                      spreadRadius: 3)
                ]),
                width: double.infinity,
                height: 160,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Nama :",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              Text(
                                nama_lengkap1,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "No Wa :",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              Text(
                                no_wa1,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('location')
                                    .where('userid', isEqualTo: idku)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Center(
                                    child: ListView.builder(
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Googlemap(snapshot.data
                                                            .docs[index].id)));
                                          },
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Text(
                                                    snapshot.data
                                                        .docs[index]["latitude"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black)),
                                                Text("<->"),
                                                Text(
                                                    snapshot
                                                        .data
                                                        .docs[index]
                                                            ["longitude"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            height: 40,
                            width: double.infinity,
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 30,
                          width: 130,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Colors.blue[900],
                              child: Text(
                                'Add Lokasi',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                              onPressed: () async {
                                _getLocation();

                                Fluttertoast.showToast(
                                    msg: " Lokasi Berhasil Ditambah");
                              }),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          width: 130,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Colors.green,
                              child: Text(
                                'Enable',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              onPressed: () async {
                                _listenLocation();
                                Fluttertoast.showToast(
                                    msg: "Location Di Hidupkan");
                              }),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          width: 130,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Colors.red[900],
                              child: Text(
                                'Disable',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              onPressed: () async {
                                _stopListinglocation();
                                Fluttertoast.showToast(
                                    msg: "Location Di Matikan");
                              }),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          width: 130,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: Colors.amber,
                              child: Text(
                                'Tracking',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tracking()));
                              }),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _stopListinglocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(idku).set({
        'online': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }

    _locationSubscription?.cancel();

    setState(() {
      _locationSubscription = null;
    });
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      await FirebaseFirestore.instance.collection('location').doc(idku).set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'name': nama_lengkap1,
        'userid': idku,
        'no_wa': no_wa1,
        'online': 1,
      }, SetOptions(merge: true));
    });
  }

  void _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(idku).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': nama_lengkap1,
        'userid': idku,
        'no_wa': no_wa1,
        'online': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  _requestpermision() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("OK");
    } else if (status.isDenied) {
      _requestpermision();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
