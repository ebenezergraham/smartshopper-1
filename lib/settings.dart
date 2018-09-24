import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),

      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          children: <Widget>[
            new Text('Add Widgets Here')
          ],
        ),
      ),
    );
  }
}