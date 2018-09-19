import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyHomepage(),
  ));
}

class MyHomepage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyHomepage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("SmartShopper"),
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