import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:smartshopper/components/service_constants.dart';

class ViewMapPage extends StatefulWidget {
  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<ViewMapPage> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(API_KEY);
  Uri staticMapUri;

  List<Marker> markers = <Marker>[
    new Marker("1", "BSR Restuarant", 28.421364, 77.333804,
        color: Colors.amber),
    new Marker("2", "Flutter Institute", 28.418684, 77.340417,
        color: Colors.redAccent),
  ];

  showMap() {
    MapView.setApiKey(API_KEY);
    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition: new CameraPosition(new Location(Long, Lat), 3.0),
        showUserLocation: true,
        title: "Recent Location"));
    mapView.setMarkers(markers);
    mapView.zoomToFit(padding: 100);

    mapView.onMapTapped.listen((_) {
      setState(() {
        mapView.setMarkers(markers);
        mapView.zoomToFit(padding: 100);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    cameraPosition = new CameraPosition(new Location(Long, Lat), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(new Location(Long, Lat), 12,
        height: 1800, width: 900, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Directions To Store"),
      ),
      body: new Container(
        height: 1800.0,
        child: new Stack(
          children: <Widget>[
            new InkWell(
              child: new Center(
                child: new Image.network(staticMapUri.toString()),
              ),
              onTap: showMap,
            )
          ],
        ),
      ),
    );
  }
}
