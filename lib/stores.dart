import 'package:flutter/material.dart';

class Stores extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<Stores>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Smart Stores"),
      ),

      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          children: <Widget>[
            new Text('Add Map Here')
          ],
        ),
      ),
    );
  }
}