import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class Googlemap extends StatefulWidget {
  final String user_id;

  Googlemap(this.user_id);

  @override
  State<Googlemap> createState() => _GooglemapState();
}

class _GooglemapState extends State<Googlemap> {
  final loc.Location location = loc.Location();
  GoogleMapController _controller;
  bool _add = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_add) {
            mymap(snapshot);
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                infoWindow: InfoWindow(
                  title: snapshot.data.docs.singleWhere(
                      (element) => element.id == widget.user_id)['name'],
                  snippet: snapshot.data.docs.singleWhere(
                      (element) => element.id == widget.user_id)['no_wa'],
                ),
                markerId: MarkerId('id'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
                position: LatLng(
                  snapshot.data.docs.singleWhere(
                      (element) => element.id == widget.user_id)['latitude'],
                  snapshot.data.docs.singleWhere(
                      (element) => element.id == widget.user_id)['longitude'],
                ),
              )
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data.docs.singleWhere(
                    (element) => element.id == widget.user_id)['latitude'],
                snapshot.data.docs.singleWhere(
                    (element) => element.id == widget.user_id)['longitude'],
              ),
              zoom: 14.47,
            ),
            onMapCreated: (GoogleMapController controller) async {
              setState(() {
                _controller = controller;
                _add = true;
              });
            },
          );
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        snapshot.data.docs
            .singleWhere((element) => element.id == widget.user_id)['latitude'],
        snapshot.data.docs.singleWhere(
            (element) => element.id == widget.user_id)['longitude'],
      ),
      zoom: 15,
    )));
  }
}
