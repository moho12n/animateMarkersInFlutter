import 'dart:typed_data';
import 'dart:async';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../tools/tools.dart';

//********* Global Variables */

const LatLng _center = const LatLng(36.737232, 3.086472);
LatLng newPosition;
CameraPosition newCameraPosition =
    CameraPosition(target: LatLng(36.6993, 3.1755), zoom: 10);

Set<Marker> markers = {};
int _index = 0;
int indexMarker;
ValueNotifier valueNotifier = ValueNotifier(indexMarker);

//*********StatefulWidget */
class MainMapScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainMapScreen> {
  //******** Map variables */
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  //******* getMarkers */
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void getMarkers() async {
    final Uint8List userMarkerIcon =
        await getBytesFromAsset('assets/normalMarker.png', 75);

    final Uint8List selectedMarkerIcon =
        await getBytesFromAsset('assets/selectedMarker.png', 100);

    markers = {};

    Tools.markersList.forEach((element) {
      if (element.latitude != null && element.longitude != null) {
        if (element.id == indexMarker) {
          markers.add(Marker(
              draggable: false,
              markerId: MarkerId(element.latitude + element.longitude),
              position: LatLng(
                double.tryParse(element.latitude),
                double.tryParse(element.longitude),
              ),
              icon: BitmapDescriptor.fromBytes(selectedMarkerIcon),
              infoWindow: InfoWindow(title: element.name)));
        } else {
          markers.add(Marker(
              draggable: false,
              markerId: MarkerId(element.latitude + element.longitude),
              position: LatLng(
                double.tryParse(element.latitude),
                double.tryParse(element.longitude),
              ),
              icon: BitmapDescriptor.fromBytes(userMarkerIcon),
              infoWindow: InfoWindow(title: element.name)));
        }
      }
    });

    valueNotifier.value = indexMarker;
  }

    //******** OnMapCreated */
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
      _controller.complete(controller);
    }

  @override
  void initState() {
    getMarkers();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 0,
        builder: (context, snapshot) {
          return Scaffold(
              body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ValueListenableBuilder(
                    valueListenable: valueNotifier, // that's the value we are listening to 
                    builder: (context, value, child) {
                      return GoogleMap(
                          zoomControlsEnabled: false,
                          markers: markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 11.0,
                          ));
                    }),
              ),
              // Here is tha PageView Builder
              Align(
                  alignment: Alignment.bottomCenter,                  
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 78.0),
                    child: SizedBox(
                      height: 116, // card height
                      child: PageView.builder(
                        itemCount: Tools.markersList.length,
                        controller: PageController(viewportFraction: 0.9),
                        onPageChanged: (int index) {
                          setState(() => _index = index);
                          indexMarker = Tools.markersList[index].id;
                          if (Tools.markersList[index].latitude != null &&
                              Tools.markersList[index].longitude != null) {
                            newPosition = LatLng(
                                double.tryParse(
                                    Tools.markersList[index].latitude),
                                double.tryParse(
                                    Tools.markersList[index].longitude));
                            newCameraPosition =
                                CameraPosition(target: newPosition, zoom: 15);
                          }
                          getMarkers();
                          mapController
                              .animateCamera(CameraUpdate.newCameraPosition(
                                  newCameraPosition))
                              .then((val) {
                            setState(() {});
                          });
                        },
                        itemBuilder: (_, i) {
                          return Transform.scale(
                            scale: i == _index ? 1 : 0.9,
                            child: new Container(
                              height: 116.00,
                              width: 325.00,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.5, 0.5),
                                    color:
                                        Color(0xff000000).withOpacity(0.12),
                                    blurRadius: 20,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.00),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9, top: 7, bottom: 7, right: 9),
                                    child: Container(
                                      height: 86.00,
                                      width: 86.00,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              Tools.markersList[i].image),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.00),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, right: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 2,
                                          direction: Axis.vertical,
                                          children: <Widget>[
                                            Text(
                                              Tools.markersList[i].name,
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                            Container(
                                              width: 230,
                                              child: Text(
                                                Tools.markersList[i]
                                                    .description,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                maxLines: 4,
                                                style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 10,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ))
            ],
          ));
        });
  }}