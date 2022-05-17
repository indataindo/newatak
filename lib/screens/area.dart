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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPostion == null
          ? CircularProgressIndicator()
          : GoogleMap(
              mapType: MapType.hybrid,
              markers: Set.from(myMarker),
              onTap: _hendleTap,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: currentPostion, zoom: 15)),
    );
  }
}
