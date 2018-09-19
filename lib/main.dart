import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:smartshopper/homepage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FacebookLogin _fbLogin = new FacebookLogin();

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Firebase Auth Demo',
      home: new MyHomePage(title: 'Firebase Auth Demo'),
      routes: <String, WidgetBuilder>{
        //5
        '/homepage': (BuildContext context) => new MyHomepage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      }
    }).catchError((e) {
      print(e);
    });

    return 'Successfully logged in';
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
        _message = Future<String>.value(
            'Phone numbber verification failed. Code: ${authException.code}. Message: ${authException.message}');
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: new TextField(
              controller: _phoneNoController,
              decoration: const InputDecoration(
                hintText: 'Enter phone number',
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: new RaisedButton(
              color: Colors.red,
              onPressed: () {
                if (_phoneNoController.text != null) {
                  this.testPhoneNumber = _phoneNoController.text;
                  _testVerifyPhoneNumber();
                }
              },
              child: new Icon(Icons.arrow_forward),
            ),
          ),
          new MaterialButton(
              child: const Text('Log In With Google'),
              onPressed: () {
                setState(() {
                  _message = _testSignInWithGoogle();
                });
              }),
          new MaterialButton(
              child: const Text('Log In With Facebook'),
              onPressed: () {
                _message = _loginWithFacebook();
              }),
          new FutureBuilder<String>(
              future: _message,
              builder: (_, AsyncSnapshot<String> snapshot) {
                return new Text(snapshot.data ?? '',
                    style:
                        const TextStyle(color: Color.fromARGB(255, 0, 155, 0)));
              }),
        ],
      ),
    );
  }
}
