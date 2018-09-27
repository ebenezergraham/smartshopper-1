import 'package:flutter/material.dart';

import '../models/place.dart';
import '../components/google_place_service.dart';
import 'placeDetail.dart';

class PlacesPage extends StatefulWidget {
  @override
  State createState() => new PlacesPageState();
}

class PlacesPageState extends State<PlacesPage> {
  String _currentPlaceId;
  @override
  Widget build(BuildContext context) {
    onItemTapped = () => Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new PlaceDetailPage(_currentPlaceId)));

    return _createContent();
  }

  final _biggerFont = const TextStyle(fontSize: 16.0);
  Widget _createContent() {
    if (_places == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new ListView(
        children: _places.map((f) {
          return new Card(
            child: new ListTile(
                title: new Text(
                  f.name,
                  style: _biggerFont,
                ),
                leading: Icon(
                  Icons.store_mall_directory,
                  color: Colors.black45,
                  size: 36.0,
                ),
                subtitle: new Text(f.vicinity),
                onTap: () {
                  _currentPlaceId = f.id;
                  // onItemTapped();
                  handleItemTap(f);
                }),
          );
        }).toList(),
      );
    }
  }

  List<PlaceDetail> _places;
  @override
  void initState() {
    super.initState();
    if (_places == null) {
      LocationService.get().getNearbyPlaces().then((data) {
        this.setState(() {
          _places = data;
        });
      });
    }
  }

  handleItemTap(PlaceDetail place) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new PlaceDetailPage(place.id)));
  }

  VoidCallback onItemTapped;
}
