import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Gotolocationservice {
  final String key = "AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk";

  Future<String> googlePlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var placeID = json['candidates'][0]['place_id'] as String;

    return placeID;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeID = await googlePlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var result = json['result'] as Map<String, dynamic>;
    print(result);
    return result;
  }

  Future<Map<String, dynamic>> getDirection(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var result = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['legs'][0]['steps'][1]['polyline']
          ['points'],
      'polyline_decode': PolylinePoints().decodePolyline(
          json['routes'][0]['legs'][0]['steps'][1]['polyline']['points'])
    };

    return result;
  }
}
