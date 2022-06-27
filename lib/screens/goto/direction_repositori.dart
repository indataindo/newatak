import 'package:flutter/material.dart';
import 'package:google_map_live/screens/goto/direction_modesl.dart';
import '.env.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionRepository {
  static const String baseurl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;
  DirectionRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirection({
    LatLng origin,
    LatLng destination,
  }) async {
    final response = await _dio.get(baseurl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': googleApiKey,
    });

    if (response.statusCode == 200) {
    
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
