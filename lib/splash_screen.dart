import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartshopper/main.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: Colors.redAccent, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => new SmartShopper(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacementNamed('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.black,
                            size: 50.0,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          'SmartShopper',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            //fontFamily: 'Roboto',
                            fontSize: 26.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          'Hustle free shopping',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 5.0)
                    ),
                    Text(
                      'Created by MoshTech',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                        fontSize: 12.0,
                        color: Colors.white
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 50.0)
                    ),
                    LinearProgressIndicator(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
