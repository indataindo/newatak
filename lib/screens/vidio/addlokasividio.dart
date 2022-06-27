import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_map_live/restapi/restApi.dart';
import 'package:google_map_live/screens/vidio/uploadvidio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:http/http.dart' as http;

class Addlokasividio extends StatefulWidget {
  const Addlokasividio({Key key}) : super(key: key);

  @override
  State<Addlokasividio> createState() => _AddlokasividioState();
}

class _AddlokasividioState extends State<Addlokasividio> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  LatLng currentPostion;
  Location _location = Location();
  Set<Marker> _markers = Set();

  Completer<GoogleMapController> _controller = Completer();

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
                  'Silahkan tambah Vidio Lokasi',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
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
                  'Nama Lokasi',
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: namalokasiicontroller,
                  decoration: InputDecoration(hintText: "Nama Lokasi"),
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
    final response = await http.post(Uri.parse(RestApi.addvidiolokasi), body: {
      "namalokasi": namalokasiicontroller.text,
      "latitude": lat,
      "longitude": long,
    });
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    int idvidio = data['idvidio'];

    if (value == 1) {
      //pesan();

      namalokasiicontroller.text = '';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Uploadvidio(
                    id: idvidio,
                  )));
    } else {
      print("Data gagal");
    }
  }

  int ty = 0;
  var maptype = MapType.normal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
