import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import './homepage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // function to change the color of the status bar of phone while the app is running
  // changeStatusColor(Color color) async {
  //   try {
  //     await FlutterStatusbarcolor.setStatusBarColor(color);
  //     if (useWhiteForeground(color)) {
  //       FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  //       FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  //     } else {
  //       FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  //       FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  //     }
  //   } on PlatformException catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // // function to change the color of navigation bar of phone while the app is running
  // changeNavigationColor(Color color) async {
  //   try {
  //     await FlutterStatusbarcolor.setNavigationBarColor(color);
  //   } on PlatformException catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = new GoogleSignIn();
  
  
  Widget _getlogin(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Google-Signin'),
                onPressed: _gSignin(),
                color: Colors.red[900],
              ),
            ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // calling the functions to change the color of navigation bar and status bar
    //changeStatusColor(Colors.grey[200]);
    //changeNavigationColor(Colors.grey[200]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greatest app',
      home: _getlogin(context),
      // home: HomePage(),
    );
  }
}
