import 'package:flutter/material.dart';
import 'package:smartshopper/login.dart';
import 'package:smartshopper/splash_screen.dart';
import 'package:smartshopper/cart.dart';
import 'package:smartshopper/homepage.dart';


void main() => runApp(SmartShopper());

class SmartShopper extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/splashScreen': (BuildContext context) => new SplashScreen(),
    '/homepage': (BuildContext context) => new MyHomepage(),
    '/login': (BuildContext context) => new MyApp(),
    '/cart': (BuildContext context) => new Cart(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartShopper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primaryColor: Colors.redAccent,
          accentColor: Colors.yellowAccent),
      home: SplashScreen(),
      routes: routes,
    );
  }
}
