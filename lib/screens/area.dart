import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class Area extends StatefulWidget {
  const Area({Key key}) : super(key: key);

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  LatLng currentPostion;
  Location _location = Location();
  final loc.Location location = loc.Location();

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  List<Marker> myMarker = [];

    _hendleTap(LatLng tappoint) {
    print(tappoint);
    setState(() {
      //  myMarker = [];
      myMarker.add(Marker(
          draggable: true,
          onDragEnd: (dragend) {
            print(dragend);
          },
          position: tappoint,
          markerId: MarkerId(tappoint.toString())));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
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
          ? CircularProgressIndicator()
          : GoogleMap(
              mapType: maptype,
              markers: Set.from(myMarker),
              onTap: _hendleTap,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: currentPostion, zoom: 15)),
    );
  }
}
