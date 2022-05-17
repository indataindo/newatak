import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_map_live/core/database/database.dart';
import 'package:google_map_live/core/models/location_model.dart';
import 'package:google_map_live/core/models/mylist.dart';
import 'package:google_map_live/core/models/polymaker_model.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class PolyMakerDB {
  //Instance database helper
  var helper = new DatabaseHelper();

  Future getAll() async {
    int id;
    String title;
    List<DocumentSnapshot> carparkList = [];
    List<MyList> myList = [];
    List<String> dataku = [];
    int idterakhir = 0;

    QuerySnapshot _myDocc =
        await FirebaseFirestore.instance.collection('polygon').get()
            // ignore: missing_return
            .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach(
        (DocumentSnapshot cp) {
          carparkList.add(cp);
          //  print(cp.data());
          id = cp['id'];
          title = cp['title'];

          myList.add(
            MyList(
              id: cp['id'],
              title: cp['title'],
            ),
          );

          //  myList = cp.data();
        },
      );
    });

    final response = await http.get(Uri.parse(RestApi.getpolygon));
    if (response.contentLength == 2) {
    } else {
      final datapromo = jsonDecode(response.body);
      var result = datapromo;

      // print("ini dari server ");
      // print(result);
      // print("------------------------------");

      Database db = await helper.database;
      //var result = await db.query("polygon");

      //var result = await myList.toList();

      return result;
    }
  }

  Future getLocationByPolygonID(int id) async {
    Database db = await helper.database;

    //  var result =
    //    await db.rawQuery("select * from location where polygon_id = ${id}");

    final response = await http.post(Uri.parse(RestApi.getlatlang), body: {
      "idpolygon": id.toString(),
    });
    if (response.contentLength == 2) {
    } else {
      final datalatlang = jsonDecode(response.body);
    
      var result = datalatlang;

      return result;
    }

    //  return result;
  }

  Future<int> create(PolyMakerModel polyMakerModel) async {
    /*
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference polygon = firestore.collection('polygon');
    CollectionReference lokasi = firestore.collection('lokasi');

    QuerySnapshot _myDoc =
        await FirebaseFirestore.instance.collection('polygon').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    var idku = 1 + _myDocCount.length;

    try {
      var res = await FirebaseFirestore.instance
          .collection('polygon')
          .doc(idku.toString())
          .set({
        'title': polyMakerModel.title,
      }, SetOptions(merge: true));

      polyMakerModel.location.forEach((location) async {
        var locModel = LocationModel(
            latitude: location.latitude,
            longitude: location.longitude,
            polygonID: idku);

        lokasi.add(locModel.toMap());
      });
    } catch (e) {
      print(e);
    }
*/

    try {
      final response = await http.post(Uri.parse(RestApi.polygon), body: {
        "title": polyMakerModel.title,
      });
      final data = jsonDecode(response.body);
      int value = data['value'];
      String pesan = data['message'];
      var idterakhir = data['value'];

      print("object");
      print(idterakhir.toString());

      polyMakerModel.location.forEach((location) async {
        final responsea = await http.post(Uri.parse(RestApi.latlang), body: {
          "polygon_id": idterakhir.toString(),
          "latitude": location.latitude.toString(),
          "longitude": location.longitude.toString()
        });
      });
    } catch (e) {
      print(e);
    }

    Database db = await helper.database;
    var result = db.insert("polygon", polyMakerModel.toMap());
    //insert location
    polyMakerModel.location.forEach((location) async {
      var locModel = LocationModel(
          latitude: location.latitude,
          longitude: location.longitude,
          polygonID: await result);

      db.insert("location", locModel.toMap());
    });

    return result;
  }
}
