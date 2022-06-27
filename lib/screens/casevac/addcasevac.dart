import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/casevac/viewcasevac.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Addcasevac extends StatefulWidget {
  const Addcasevac({Key key}) : super(key: key);

  @override
  State<Addcasevac> createState() => _AddcasevacState();
}

class _AddcasevacState extends State<Addcasevac> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  LatLng currentPostion;
  Location _location = Location();
  Set<Marker> _markers = Set();

  Completer<GoogleMapController> _controller = Completer();

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
      print("ini id dari casevac");
      print(idku);
    });
  }

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();

    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  String lat = "";
  String long = "";
  TextEditingController namalokasiicontroller = new TextEditingController();

  Future<void> pesan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Berhasil Tersimpan',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Viewcasevac()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pesanbookmark() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Pesan',
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: namalokasiicontroller,
                  decoration: InputDecoration(hintText: "Pesan"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('SIMPAN'),
              onPressed: () {
                simpanvidiolokasi();
              },
            ),
          ],
        );
      },
    );
  }

  bool loading = false;
  simpanvidiolokasi() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse(RestApi.casevac), body: {
      "iduser": idku,
      "pesan": namalokasiicontroller.text,
      "status": "1",
      "latitude": lat,
      "longitude": long,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    if (value == 1) {
      pesan();
      namalokasiicontroller.text = '';
    } else {
      print("Data gagal");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getProfiles();
  }

  int ty = 0;
  var maptype = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: currentPostion == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onTap: (LatLng latLng) {
                _markers
                    .add(Marker(markerId: MarkerId('mark'), position: latLng));
                setState(() async {
                  lat = latLng.latitude.toString();
                  long = latLng.longitude.toString();
                  print("ini lokasi nya");
                  print(lat);
                  print(long);
                  pesanbookmark();
                });
              },
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              mapType: maptype,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(zoom: 15, target: currentPostion)),
    );
  }
}
