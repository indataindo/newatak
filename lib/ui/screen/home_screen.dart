import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_live/core/viewmodels/map_provider.dart';
import 'package:google_map_live/ui/Animation/FadeAnimation.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  var titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //To modify status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Consumer<MapProvider>(
      builder: (context, mapProv, _) {
        //Get first location
        if (mapProv.cameraPosition == null) {
          mapProv.initCamera();
        }

        return Center(
          child: Stack(
            children: <Widget>[
              mapProv.cameraPosition != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        compassEnabled: false,
                        tiltGesturesEnabled: false,
                        markers: mapProv.markers,
                        mapType: MapType.hybrid,
                        initialCameraPosition: mapProv.cameraPosition,
                        onMapCreated: mapProv.onMapCreated,
                        mapToolbarEnabled: false,
                        onTap: (loc) {
                          //print(loc);
                          mapProv.maptap(loc);
                        },
                        polygons: mapProv.polygons,
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
                          mapProv.isEditMode == true
                              ? FadeAnimation(
                                  delay: 0.8,
                                  child: InkWell(
                                    onTap: () => mapProv.undoLocation(),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.undo,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: mapProv.isEditMode == true ? 10 : 0),
                          mapProv.isEditMode == true
                              ? FadeAnimation(
                                  delay: 0.5,
                                  child: InkWell(
                                    onTap: () => mapProv.savePolygon(
                                        titleController, context),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(width: mapProv.isEditMode == true ? 10 : 0),
                          InkWell(
                            onTap: () => mapProv.changeEditMode(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                mapProv.isEditMode == false
                                    ? Icons.edit_location
                                    : Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () => mapProv
                                .changeCameraPosition(mapProv.sourceLocation),
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
      },
    );
  }
}
