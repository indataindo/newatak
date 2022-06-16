import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_live/screens/goto/direction_modesl.dart';
import 'package:google_map_live/screens/goto/direction_repositori.dart';
import 'package:google_map_live/screens/goto/gotolocationservice.dart';
import 'package:google_map_live/screens/goto/placeservice.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

//import 'package:map_launcher_example/show_directions.dart';
//import 'package:map_launcher_example/show_marker.dart';

class Goto extends StatefulWidget {
  const Goto({Key key}) : super(key: key);

  @override
  State<Goto> createState() => _GotoState();
}

enum LaunchMode { marker, directions }

class _GotoState extends State<Goto> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LatLng currentPostion;
  Location _location = Location();
//add origin and map
  // GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;

  void dispose() {
    _destinationController.dispose();
    // _googleMapController.dispose();
    super.dispose();
  }

  void getLocation() async {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() {
      currentPostion =
          LatLng(_locationResult.latitude, _locationResult.longitude);
    });
  }

  TextEditingController _originController = new TextEditingController();
  TextEditingController _destinationController = new TextEditingController();
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polygonsLatLng = <LatLng>[];
  int _polygonIdCount = 1;
  int _polylineIdCount = 1;

  var uuid = Uuid();
  String sessiontoken = '122344';
  List<dynamic> _place = [];

// final Texteditingcontroller _destinationController = TextEditingController();
  PlaceApi _placeApi = PlaceApi.instance;
  bool buscando = false;
  List<Place> _predictions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarker(LatLng(-1.637679631516086, 103.60008716583252));

    getLocation();
    _originController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (sessiontoken == null) {
      setState(() {
        sessiontoken = uuid.v4();
        ab = true;
      });
    }
    sessiontoken = uuid.v4();
    //ab = true;
    getSugestion(_originController.text);
  }

  void getSugestion(String input) async {
    String googleApiKey = 'AIzaSyDa8nbajHMiviV87-4DRPhyB4ukjuuSZhk';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$googleApiKey&sessiontoken=$sessiontoken';
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _place = jsonDecode(response.body.toString())['predictions'];
        print("ini dataprediksi");
        print(_place);
      });
    } else {
      throw Exception('filed to load');
    }
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(markerId: MarkerId('marker'), position: point));
    });
  }

  void _setpolygons() {
    final String polygonsIDval = 'PolygonID_$_polygonIdCount';
    _polygonIdCount++;
    _polygons.add(Polygon(
        polygonId: PolygonId(polygonsIDval),
        points: polygonsLatLng,
        strokeWidth: 2,
        fillColor: Colors.red.withOpacity(0.1)));
  }

  void _setpolyline(List<PointLatLng> points) {
    final String polylineIDval = 'polyline$_polylineIdCount';
    _polylineIdCount++;
    _polylines.add(Polyline(
        polylineId: PolylineId(polylineIDval),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList()));
  }

  bool ab = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Go To"),
        /*
        actions: [
          if (_origin != null)
            TextButton(
                onPressed: () {
                  _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: _origin.position, zoom: 15, tilt: 50.0)));
                },
                child: Text("ORIGIN")),
          if (_destination != null)
            TextButton(
                onPressed: () {
                  _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: _destination.position,
                          zoom: 15,
                          tilt: 50.0)));
                },
                child: Text("DESTINATION")),
        ],
    */
      ),
      body: Stack(
        children: [
          if (currentPostion == null)
            Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _originController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: "Origin ",
                              ),
                              //  onChanged: (value) {},
                            ),
                          ),
/*
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _destinationController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: "Destination ",
                              ),
                              //  onChanged: (value) {},
                            ),
                          )
*/
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          var direction = await Gotolocationservice()
                              .getDirection(_originController.text,
                                  _destinationController.text);

                          //  var place = await Gotolocationservice()
                          //       .getPlace(_searchcontroller.text);

                          _gotoPlace(
                            direction['start_location']['lat'],
                            direction['start_location']['lng'],
                            direction['bounds_ne'],
                            direction['bounds_sw'],
                          );

                          _setpolyline(direction['polyline_decode']);
                        },
                        icon: Icon(Icons.search))
                  ],
                ),

/*
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _searchcontroller,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Search ",
                      ),
                      onChanged: (value) {},
                    )),
               
*/

                // if (ab == true)
/*
                Expanded(
                    child: ListView.builder(
                  itemCount: _place.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_place[index]['description']),
                    );
                  },
                )),
*/
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) =>
                        _controller.complete(controller),
                    markers: _markers,
                    polygons: _polygons,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    polylines: _polylines,
                    onTap: (point) {
                      setState(() {
                        polygonsLatLng.add(point);
                        _setpolygons();
                      });
                    },

                    /*
                        polylines: {
                          if (_info != null)
                            Polyline(
                                polylineId: const PolylineId("overview_polylines"),
                                color: Colors.red,
                                width: 5,
                                points: _info.polylinepoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList()),
                        },
                */

                    mapType: MapType.hybrid,
                    initialCameraPosition:
                        CameraPosition(target: currentPostion, zoom: 15),
                  ),
                ),
              ],
            ),
          if (_info != null)
            Positioned(
                top: 20,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${_info.totaldistance},${_info.totaldurations}"),
                )),
        ],
      ),
    );
  }

  void _addMarker(LatLng argument) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            position: argument);

        _destination = null;
      });
    } else {
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: argument);
      });
      final directions = await DirectionRepository().getDirection(
        origin: _origin.position,
        destination: _destination.position,
      );
      setState(() => _info = directions);
    }
  }

  Future<void> _gotoPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    //final double lat = place['geometry']['location']['lat'];
    //final double lng = place['geometry']['location']['lng'];

    final GoogleMapController _googleMapController = await _controller.future;
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));
    _setMarker(LatLng(lat, lng));
  }
}
