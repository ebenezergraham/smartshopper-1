import 'package:flutter/material.dart';
import 'package:smartshopper/contact.dart';
import 'package:smartshopper/login.dart';
import 'package:smartshopper/my_profile.dart';
import 'package:smartshopper/settings.dart';
import 'package:smartshopper/splash_screen.dart';
import 'package:smartshopper/cart.dart';
import 'package:smartshopper/homepage.dart';
import 'package:smartshopper/store_views/map_view.dart';
import 'package:smartshopper/store_views/stores.dart';

void main() => runApp(SmartShopper());

class SmartShopper extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/splashScreen': (BuildContext context) => new SplashScreen(),
    '/homepage': (BuildContext context) => new MyHomepage(),
    '/login': (BuildContext context) => new LoginPage(),
    '/cart': (BuildContext context) => new Cart(),
    '/profile': (BuildContext context) => new MyProfile(),
    '/settings': (BuildContext context) => new Settings(),
    '/contact': (BuildContext context) => new Contact(),
    '/stores': (BuildContext context) => new Stores(),
    '/map_view': (BuildContext context) => new ViewMapPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartShopper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primaryColor: Colors.redAccent,
          accentColor: Colors.redAccent),
      home: SplashScreen(),
      routes: routes,
    );
  }
}
