import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinepoints;
  final String totaldistance;
  final String totaldurations;

  const Directions(
      {this.bounds,
      this.polylinepoints,
      this.totaldistance,
      this.totaldurations});

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) return null;

    final data = Map<String, dynamic>.from(map['routes'][0]);
    print("ini polyline ku");
    print(data['legs'][0]['steps'][1]['polyline']['points']);


    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
        southwest: LatLng(southwest['lat'], southwest['lng']),
        northeast: LatLng(northeast['lat'], northeast['lng']));

    //distance and duration

    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
        bounds: bounds,
        polylinepoints:
            PolylinePoints().decodePolyline(data['legs'][0]['steps'][1]['polyline']['points']),
        totaldistance: distance,
        totaldurations: duration);
  }
}
