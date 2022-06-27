import 'dart:convert';

import 'package:google_map_live/core/database/polymaker_db.dart';
import 'package:google_map_live/core/models/getid.dart';
import 'package:google_map_live/core/models/location_model.dart';
import 'package:google_map_live/core/models/mylist.dart';
import 'package:google_map_live/core/models/polymaker_model.dart';

class PolyMakerServices {
  //Instance polymaker database
  static PolyMakerDB _polyMakerDb = new PolyMakerDB();
  String id;
  String title;
  List<String> dataku = [];
  //Function to get all polygon locations
  Future<List<PolyMakerModel>> getAll() async {
    var _result = await _polyMakerDb.getAll();

    var data = new List<PolyMakerModel>();

    for (var polyMaker in _result) {
   
      var _locResult =
          await _polyMakerDb.getLocationByPolygonID(polyMaker["id"]);
          
      var _locData = new List<LocationModel>();

      for (var value in _locResult) {
        _locData.add(LocationModel.fromMap(value));
      }

      data.add(PolyMakerModel.fromMap(polyMaker, _locData));
    }

    return data;
  }

  //Function to create polygon to database
  Future<bool> create(PolyMakerModel polyMakerModel) async {
    var _result = await _polyMakerDb.create(polyMakerModel);

    if (_result != null) {
      return true;
    } else {
      return false;
    }
  }
}
