import 'package:dio/dio.dart';
import 'dart:io';

class Place {
  final String placeId, description;

  Place({this.placeId, this.description});
  static Place fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['placeId'],
      description: json['description'],
    );
  }
}

class PlaceApi {
  PlaceApi._internal();
  static PlaceApi get instance => PlaceApi._internal();
  final Dio _dio = Dio();

  static final String androidKey = 'AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk';
  static final String iosKey = 'AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Place>> searchPredictions(String input) async {
    try {
      final response = await this._dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          "input": input,
          "key": apiKey,
          "types": "address",
          "language": "id",
          "components": "country:id",
        },
      );
       print(response.data);
      final List<Place> places = (response.data['predictions'] as List)
          .map((item) => Place.fromJson(item))
          .toList();
      return places;
    } catch (e) {
      return null;
    }
  }
}