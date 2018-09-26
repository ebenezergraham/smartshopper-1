import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<Cart>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Cart"),
      ),

      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          children: <Widget>[
            new Text('Cart Items go here')
          ],
        ),
      ),
    );
  }
}