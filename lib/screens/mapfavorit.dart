import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/core/config/config.dart';
import 'package:google_map_live/core/models/polymaker_model.dart';
import 'package:google_map_live/core/services/polymaker_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class Mapfavorit extends StatefulWidget {
  const Mapfavorit({Key key}) : super(key: key);

  @override
  State<Mapfavorit> createState() => _MapfavoritState();
}

class _MapfavoritState extends State<Mapfavorit> {
  var titleController = TextEditingController();
  Location location = new Location();
  LatLng _sourceLocation;
  LatLng get sourceLocation => _sourceLocation;
  CameraPosition _cameraPosition;
  CameraPosition get cameraPosition => _cameraPosition;
  String _mapStyle;
  String get mapStyle => _mapStyle;
  Completer<GoogleMapController> _completer = Completer();
  Completer<GoogleMapController> get completer => _completer;
  GoogleMapController _controller;
  GoogleMapController get controller => _controller;
  String _uniqueID = "";
  String get uniqueID => _uniqueID;
  LatLng latlang;
  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  List<LatLng> _tempLocation = new List();
  List<LatLng> get tempLocation => _tempLocation;
  BitmapDescriptor _pointIcon;
  BitmapDescriptor get pointIcon => _pointIcon;
  Set<Polygon> _tempPolygons = new Set();
  Set<Polygon> get tempPolygons => _tempPolygons;
  Set<Polygon> _polygons = new Set();
  Set<Polygon> get polygons => _polygons;
  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;
  PolyMakerServices polyMakerServices = new PolyMakerServices();
  BitmapDescriptor _polyIcon;
  BitmapDescriptor get polyIcon => _polyIcon;

  initLocation() async {
    var locData = await location.getLocation();
    _sourceLocation = LatLng(locData.latitude, locData.longitude);
    setState(() {
      latlang = _sourceLocation;
    });
  }

  initCamera() async {
    //Get current locations
    await initLocation();

    //Set current location to camera
    _cameraPosition = CameraPosition(
        zoom: 15,
        // bearing: cameraBearing,
        //tilt: cameraTilt,
        target: sourceLocation);
  }

  void onMapCreated(GoogleMapController controller) async {
    //Loading map style

    _mapStyle = await rootBundle.loadString(Config.mapStyleFile);

    _completer.complete(controller);
    _controller = controller;

    // setIcons();
    //loadPolygons();

    //Set style to map
    _controller.setMapStyle(_mapStyle);
  }

  void setTempToPolygon() {
    if (_tempPolygons != null) {
      _tempPolygons.removeWhere((poly) => poly.polygonId == uniqueID);
    }

    _tempPolygons.add(Polygon(
        polygonId: PolygonId(uniqueID),
        points: _tempLocation,
        strokeWidth: 3,
        fillColor: Colors.green.withOpacity(0.3),
        strokeColor: Colors.red));
    _polygons = _tempPolygons;
    // notifyListeners();
  }

  void setMarkerLocation(String id, LatLng _location, BitmapDescriptor icon,
      {String title}) {
    _markers.add(Marker(
        markerId: MarkerId("${uniqueID + id}"),
        position: _location,
        icon: icon,
        infoWindow: title != null
            ? InfoWindow(title: title, snippet: "Area ${id}")
            : InfoWindow(title: title, snippet: "Area ${id}")));
  }

  void maptap(LatLng _location) {
    print(_location);
    _tempLocation.add(_location);
    if (_uniqueID == "") {
      _uniqueID = Random().nextInt(10000).toString();
    }
    print("ini dari templocation");
    print(_tempLocation);
    setMarkerLocation(_tempLocation.length.toString(), _location, _pointIcon);
    setTempToPolygon();

  }

  void changeEditMode() {
    _isEditMode = !_isEditMode;

    if (_isEditMode == false) {
      _uniqueID = "";
      _tempPolygons.clear();
      _tempLocation.clear();
      _markers.clear();
      loadPolygons();
    } else {
      _polygons.clear();
      _markers.clear();
    }
    //  notifyListeners();
  }

  //Function to load all polygons saved from database
  void loadPolygons() async {
    _polygons.clear();
    _markers.clear();
    List<PolyMakerModel> result = await polyMakerServices.getAll();

    for (var polyMaker in result) {
      polygons.add(Polygon(
        polygonId: PolygonId("${polyMaker.id}-${polyMaker.title}"),
        points: polyMaker.location
            .map((val) => LatLng(val.latitude, val.longitude))
            .toList(),
        strokeWidth: 3,
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
      ));

      setMarkerLocation(
          "${polyMaker.id}",
          LatLng(
              polyMaker.location[0].latitude, polyMaker.location[0].longitude),
          _polyIcon,
          title: polyMaker.title);
    }
    // notifyListeners();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _sourceLocation != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    tiltGesturesEnabled: false,
                    markers: markers,
                    mapType: MapType.hybrid,
                    initialCameraPosition:
                        CameraPosition(target: _sourceLocation, zoom: 14),
                    onMapCreated: onMapCreated,
                    mapToolbarEnabled: false,
                    onTap: (loc) {
                      //print(loc);
                      maptap(loc);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(width: isEditMode == true ? 10 : 0),
                      InkWell(
                        onTap: () => changeEditMode(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            isEditMode == false
                                ? Icons.edit_location
                                : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
