import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FacebookLogin _fbLogin = new FacebookLogin();

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<String> _message = new Future<String>.value('');
  String verificationId;
  String testPhoneNumber; //changed
  final TextEditingController _phoneNoController = new TextEditingController();

  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    Navigator.of(context).pushReplacementNamed('/homepage');

    return 'signInWithGoogle succeeded: $user';
  }

  Future<String> _loginWithFacebook() async {
    _fbLogin
        .logInWithReadPermissions(['email', 'public_profile']).then((result) {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FirebaseAuth.instance
              .signInWithFacebook(accessToken: result.accessToken.token)
              .then((signedInUser) {
            print('Signed in as ${signedInUser.displayName}');
            Navigator.of(context).pushReplacementNamed('/homepage');
          }).catchError((e) {
            print(e);
          });
          return 'Successfully logged in';
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('CANCELED BY USER');
          break;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          break;
      }
    }).catchError((e) {
      print(e);
    });

    return 'Login failed. Please try again';
  }

  Future<void> _testVerifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        _message =
            Future<String>.value('signInWithPhoneNumber auto succeeded: $user');
        Navigator.of(context).pushReplacementNamed('/homepage');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        print(
            'Phone numbber verification failed. Code: ${authException.code}. Message: ${authException.message}');
        _message = Future<String>.value(
            'Try again. Use format +[country code][number]');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: testPhoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future toast(String message) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      bgcolor: "#e74c3c",
      textcolor: '#ffffff',
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage('lib/assets/logo.png'),
                        width: 150.0,
                        height: 150.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                    ),
                    Container(
                      width: 320.0,
                      height: 42.0,
                      child: RaisedButton(
                          color: Colors.blueAccent,
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                              Text(
                                'Login with Facebook',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () {
                            toast("Verifying...");
                            _message = _loginWithFacebook();
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Container(
                      width: 320.0,
                      height: 42.0,
                      child: RaisedButton(
                          color: Colors.redAccent,
                          elevation: 0.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                              Text(
                                'Login with Google',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              toast("Verifying...");
                              _message = _testSignInWithGoogle();
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Login with Phone Number',
                        style: TextStyle(color: Colors.black54),
                      ),
                      new Container(
                        width: 320.0,
                        margin: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: new TextFormField(
                          keyboardType: TextInputType.phone,
                          autofocus: false,
                          controller: _phoneNoController,
                          decoration: InputDecoration(
                            hintText: 'Enter phone number',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                      new FutureBuilder<String>(
                          future: _message,
                          builder: (_, AsyncSnapshot<String> snapshot) {
                            return new Text(snapshot.data ?? '',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Color.fromARGB(255, 0, 155, 0)));
                          }),
                      new Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: Colors.redAccent,
                            child: ButtonTheme(
                              minWidth: 320.0,
                              height: 42.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                //elevation: 4.0,
                                onPressed: () {
                                  toast("Verifying...");
                                  //Navigator.of(context).pushNamed('/homepage');
                                  if (_phoneNoController.text != null) {
                                    this.testPhoneNumber =
                                        _phoneNoController.text;
                                    _testVerifyPhoneNumber();
                                  }
                                },
                                color: Colors.redAccent,
                                child: Text('Log In',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
