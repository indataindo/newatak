import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_map_live/contohchat/chetscreen.dart';

import 'package:google_map_live/map.dart';
import 'package:google_map_live/newgoto/home_screen.dart';
import 'package:google_map_live/newgoto/screens/search_places_screen.dart';

import 'package:google_map_live/screens/allkeranjang.dart';
import 'package:google_map_live/screens/allkontak.dart';
import 'package:google_map_live/screens/calculate/calculate.dart';
import 'package:google_map_live/screens/casevac/addcasevac.dart';
import 'package:google_map_live/screens/casevac/viewcasevac.dart';
import 'package:google_map_live/screens/chatgroup.dart';
import 'package:google_map_live/screens/getbookmark.dart';
import 'package:google_map_live/screens/getfavorit.dart';
import 'package:google_map_live/screens/goto/goto.dart';
import 'package:google_map_live/screens/goto/searchplace.dart';
import 'package:google_map_live/screens/imagelokasi/addlokasiimage.dart';
import 'package:google_map_live/screens/imagelokasi/tambahimagecari.dart';
import 'package:google_map_live/screens/imagelokasi/viewmarker.dart';
import 'package:google_map_live/screens/liskontak.dart';
import 'package:google_map_live/screens/mapfavorit.dart';
import 'package:google_map_live/screens/redx/addredx.dart';
import 'package:google_map_live/screens/redx/viewredx.dart';
import 'package:google_map_live/screens/testscren.dart';
import 'package:google_map_live/screens/traking.dart';
import 'package:google_map_live/screens/vidio/addlokasividio.dart';
import 'package:google_map_live/screens/vidio/tambahvidio.dart';
import 'package:google_map_live/screens/vidio/tambahvidiocari.dart';
import 'package:google_map_live/screens/vidio/viewvidio.dart';
import 'package:google_map_live/ui/screen/home_screen.dart';
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

  int ty = 0;
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

  keluar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove('id');
      preferences.remove('nama_lengkap');
      preferences.remove('no_wa');

      preferences.commit();
    });
    exit(0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
    getLocation();
    _requestpermision();

    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
  }

  GoogleMapController mycontroller;
  static CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(-0.8971395757503112, 100.3507166778259), zoom: 14);
  Set<Marker> marke = {};
  var maptype = MapType.normal;
  void _onMapCreatedd(GoogleMapController controller) {
    mycontroller = controller;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference location = firestore.collection('location');
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("AMARTA"),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/atak_splash.png')),
                  color: Colors.black26),
            ),
            ExpansionTile(
              title: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPlacesScreen()));
                  },
                  child: Text('Go To ')),
            ),
            ExpansionTile(
              title: Text('Casevac'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewcasevac()));
                            },
                            child: Text('View')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addcasevac()));
                            },
                            child: Text('Tambah')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Map User Sharing'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Alluser()));
                            },
                            child: Text('Sharing Map')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Map & Favorit'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Getfavorit()));
                            },
                            child: Text('Saving Favorit Map')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Getbookmark()));
                            },
                            child: Text('BookMark Map'))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('GeoChat'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Allkontak()));
                            },
                            child: Text('List Contact')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chatgroup()));
                            },
                            child: Text('Chat Group')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Liskontak()));
                            },
                            child: Text('Chat')),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Vidio Stream'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addlokasividio()));
                            },
                            child: Text('Tambah Lokasi Vidio Stream')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Allvidio()));
                            },
                            child: Text('List Vidio')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewvidio()));
                            },
                            child: Text('View Vidio')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Image Lokasi'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewmarker()));
                            },
                            child: Text('View Image Galery')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Addlokasiimage()));
                            },
                            child: Text('Tambah Image')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Allimage()));
                            },
                            child: Text('Daftar Lokasi')),
                        SizedBox(height: 15),
                        InkWell(
                            onTap: () {
                              keluar();
                            },
                            child: Text('Logout')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Exit'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),
                        InkWell(
                            onTap: () {
                              keluar();
                            },
                            child: Text('Logout')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                  mapType: maptype,
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
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.70),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(-5, 0),
                          blurRadius: 15,
                          spreadRadius: 3)
                    ]),
                width: double.infinity,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                                  overflow: TextOverflow.ellipsis,
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
                            /*
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
                            */
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          height: 60,

                          width: MediaQuery.of(context).size.width / 1.2,
                          // color: Colors.blue,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/addlokasi.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    /*
                                    Text(
                                      'Add Lokasi',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                    */
                                    onPressed: () async {
                                      _getLocation();

                                      Fluttertoast.showToast(
                                          msg: " Lokasi Berhasil Ditambah");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/stopmylokasi.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      _stopListinglocation();
                                      Fluttertoast.showToast(
                                          msg: "Location Di Matikan");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/status_dot_green.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      _listenLocation();
                                      Fluttertoast.showToast(
                                          msg: "Location Di Hidupkan");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/carilokasi.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Testscreen()));
                                      Fluttertoast.showToast(msg: "Tracking");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/addvidio.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Addlokasividio()));
                                      Fluttertoast.showToast(msg: "Add Vidio");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/video_icon.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Viewvidio()));
                                      Fluttertoast.showToast(msg: "View Vidio");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/ic_menu_quickpic.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Addlokasiimage()));
                                      Fluttertoast.showToast(msg: "Add Image");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/ic_menu_casevac.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Viewcasevac()));
                                      Fluttertoast.showToast(msg: "Casevac");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/red_full.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Addredx()));
                                      Fluttertoast.showToast(msg: " Add Red X");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/enter_location_spot_red_pressed.9.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Viewredx()));
                                      Fluttertoast.showToast(msg: "Red X");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/ic_menu_goto_nav.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchPlacesScreen()));
                                      Fluttertoast.showToast(msg: "Go To");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/gpkg.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Alluser()));
                                      Fluttertoast.showToast(
                                          msg: "Sharing Map");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/lpt_white_star_drawable.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Getbookmark()));
                                      Fluttertoast.showToast(msg: "Boork Map");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/cot_icon_sugp.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Getfavorit()));
                                      Fluttertoast.showToast(
                                          msg: "Favorit Map");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/untrusted.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Allkontak()));
                                      Fluttertoast.showToast(
                                          msg: "List Contact Map");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/telestrate_lit.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Chatgroup()));
                                      Fluttertoast.showToast(msg: "Chat Group");
                                    }),
                              ),
                              SizedBox(width: 15),
                              Container(
                                height: 30,
                                width: 70,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Colors.black.withOpacity(0.15),
                                    child: Image.asset(
                                      'assets/rectangle_lit.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Allkontak()));
                                      Fluttertoast.showToast(msg: "Chat");
                                    }),
                              ),
                            ],
                          ),
                        ),
                        /*
                       
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
                                        builder: (context) => Testscreen()));
                              }),
                        ),
                        */
                      ],
                    ),
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
