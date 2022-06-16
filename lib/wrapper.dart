import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/botomnavy.dart';
import 'package:google_map_live/screens/dasboard.dart';
import 'package:google_map_live/signin4.dart';
import 'package:google_map_live/splash.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Wrapperr extends StatefulWidget {
  const Wrapperr({Key key}) : super(key: key);

  @override
  State<Wrapperr> createState() => _WrapperrState();
}

class _WrapperrState extends State<Wrapperr> {
  bool _isLoading = false;
  String idku = "";
  String id = "";
  int akses;

  Future<String> getProfiles() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("id").toString();

    setState(() {
      _isLoading = false;
      idku = id;
      print("ini idku");
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
    // _requestpermision();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : idku != "null"
            ? Dashboard()
            : Signin4Page();
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
