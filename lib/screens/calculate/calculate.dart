import 'package:flutter/material.dart';
import 'package:google_map_live/map.dart';
import 'package:dio/dio.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

class Calculate extends StatefulWidget {
  const Calculate({Key key}) : super(key: key);

  @override
  State<Calculate> createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  cekjarak() {
    final cityLondon = LatLng(51.5073509, -0.1277583);
    final cityParis = LatLng(48.856614, 2.3522219);

    final distance =
        SphericalUtil.computeDistanceBetween(cityLondon, cityParis) / 1000.0;

    print('Distance between London and Paris is $distance km.');
  }

  void getDistanceMatrix() async {
    try {
      var response = await Dio().get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=40.659569,-73.933783&origins=40.6655101,-73.89188969999998&key=AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk');
      
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDistanceMatrix();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
