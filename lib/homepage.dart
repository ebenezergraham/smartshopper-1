import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomepage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyHomepage> {
  String barcode = "";
  int _cartItems = 20;
  int _qty = 1;
  TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _qtyController = new TextEditingController(text: '$_qty');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("SmartShopper"),
          actions: <Widget>[
            new Container(
              child: new GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/cart');
                },
                child: new Stack(
                  children: <Widget>[
                    IconButton(
                      icon: new Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/cart');
                      },
                    ),
                    _cartItems == 0
                        ? new Container()
                        : new Positioned(
                            child: new Stack(
                            children: <Widget>[
                              new Icon(
                                Icons.brightness_1,
                                size: 20.0,
                                color: Colors.yellowAccent,
                              ),
                              new Positioned(
                                  top: 3.0,
                                  right: 4.0,
                                  child: new Center(
                                    child: new Text(
                                      _cartItems.toString(),
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                            ],
                          ))
                  ],
                ),
              ),
            )
          ],
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text('Apondi Kevin Omondi'),
                accountEmail: new Text('kevpreneur@gmail.com'),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text('A'),
                ),
              ),
              new ListTile(
                title: new Text('My Profile'),
                trailing: new Icon(Icons.person),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
              new ListTile(
                title: new Text('Settings'),
                trailing: new Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              new ListTile(
                title: new Text('Contact Us'),
                trailing: new Icon(Icons.phone),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/contact');
                },
              ),
              new Divider(),
              new ListTile(
                title: new Text('Logout'),
                trailing: new Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Container(
                          child: new Card(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new ListTile(
                              leading: const Icon(Icons.location_on),
                              subtitle:
                                  const Text('Discover smart stores nearby'),
                              title: new Text('Stores near me'),
                              onTap: () {
                                Navigator.of(context).pushNamed('/stores');
                              },
                            ),
                          ],
                        ),
                      )),
                      Container(
                          child: new Card(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: const Icon(Icons.announcement),
                              title: const Text('Promotions'),
                              subtitle:
                                  const Text('Discover promotions near me'),
                              onTap: null,
                            ),
                          ],
                        ),
                      )),
                      Container(
                          child: new Card(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: const Icon(Icons.shopping_basket),
                              title: const Text('Shopping list'),
                              subtitle: const Text('Manage your shopping list'),
                              onTap: null,
                            ),
                          ],
                        ),
                      )),
                      Container(
                          child: new Card(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: const Icon(Icons.local_taxi),
                              title: const Text('Taxi'),
                              subtitle: const Text('Find a ride home'),
                              onTap: null,
                            ),
                          ],
                        ),
                      )),
                      Text(barcode)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Container(
                        child: new RaisedButton(
                          padding: new EdgeInsets.all(15.0),
                          color: Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.code,
                                color: Colors.white,
                              ),
                              Text(
                                'Scan to Shop',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onPressed: scan,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      modal();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        toast("Allow camera permission to proceed");
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      toast("No product scanned");
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future toast(String message) async {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        bgcolor: "#e74c3c",
        textcolor: '#ffffff');
  }

  Future modal() async {
    this._qty = 1;
    _qtyController.text = _qty.toString();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            color: Colors.redAccent,
            //padding: EdgeInsets.only(
            //    left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
            child: new Column(
              children: <Widget>[
                new Expanded(
                    flex: 2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Item Name and Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Price: ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        Divider(),
                        Container(
                          width: 200.0,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  'Quantity:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0),
                              ),
                              new Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => setState(() {
                                        if (v != null) {
                                          _qty = int.tryParse(v);
                                        } else {
                                          _qty = 1;
                                        }
                                      }),
                                  controller: _qtyController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 8.0, 20.0, 8.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: _removeQuantity,
                              child:
                                  new Icon(Icons.remove, color: Colors.black),
                              color: Colors.white,
                            ),
                            new RaisedButton(
                              onPressed: _addQuantity,
                              child: new Icon(Icons.add, color: Colors.black),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    )),
                Divider(),
                new Column(

                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Expanded(
                          child: ButtonTheme(
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: _removeQuantity,
                              child: new Text(
                                'CANCEL',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        new Expanded(
                          child: ButtonTheme(
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: _removeQuantity,
                              child: new Text(
                                'ADD TO CART',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _addQuantity() {
    _qty++;
    print(_qty);
    _qtyController.text = _qty.toString();
  }

  void _removeQuantity() {
    if (_qty > 1) {
      this._qty--;
      _qtyController.text = _qty.toString();
    }
    print(_qty);
  }
}
