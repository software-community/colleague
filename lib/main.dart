import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import './homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
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
  String username = 'not asigned';
  String token;
  SharedPreferences prefs;
  Widget home;
  Widget _getlogin(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(username),
            FlatButton(
              child: Text('Google-Signin'),
              onPressed: () {
                _gSignin();
              },
              color: Colors.red[900],
            ),
            FlatButton(
              child: Text('Google-Signout'),
              onPressed: (){
                _gLogout();
              },
            ),
          ],
        ),
      ),
    );
  }

  _gLogout(){
    _googleSignin.signOut();
    prefs.setString("token", "");
  }

  Future<String> _checklogin() async {
    print("check login called");
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
    if(token == "" || token ==null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _getlogin(context)),
      );
    }else{
    //  print("inside elser");
      _gSignin();
    }
    return null;
  }

  Future<FirebaseUser> _gSignin() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignin.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    prefs.setString('token', await user.getIdToken());
    print("User is: ${user.displayName}");
    //setState((){
    //    home = HomePage();
    //});
    return user;
  }
  Future<void> randomfunc() async {
    print('stop calling me');
  }
  @override
  Widget trial(){
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('button'),
          onPressed: (){
            _gLogout();
          },
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    // calling the functions to change the color of navigation bar and status bar
    //changeStatusColor(Colors.grey[200]);
    //changeNavigationColor(Colors.grey[200]);
    home = trial();
    //print('build');
    //randomfunc();
    _checklogin();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greatest app',
      home: home,
      // home: HomePage(),
    );
  }
}
