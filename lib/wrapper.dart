import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/botomnavy.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/signin4.dart';
import 'package:google_map_live/splash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
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

class Wrapperr extends StatefulWidget {
  const Wrapperr({Key key}) : super(key: key);

  @override
  State<Wrapperr> createState() => _WrapperrState();
}

class _WrapperrState extends State<Wrapperr> {
    final loc.Location location = loc.Location();
  bool _isLoading = false;
  String idku = "0";
  String id = "";
  int akses;


  LatLng currentPostion;
  Location _location = Location();
 void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
    
  }
  


  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      print(idku);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    getProfiles();

     _requestpermision();
       location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : idku == "null"
            //? //Dashboard()
            ? Signin4Page()
            : Dashboard();
  }

  _requestpermision() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      _requestpermision();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
