import 'package:flutter/material.dart';
import 'package:smartshopper/store_views/places.dart';

class Stores extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<Stores> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Smart Stores Near You "),
      ),
      body: new Container(
        padding: new EdgeInsets.all(10.0),
        child: PlacesPage(),
      ),
    );
  }
}
