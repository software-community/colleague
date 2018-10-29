import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './auth.dart';
import './login.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import './homepage.dart';
SharedPreferences myprefs;
Widget _defaulthome;
Auth auth = Auth();
void main() async{
  _defaulthome = LoginPage();
  myprefs = await SharedPreferences.getInstance();
  String token = myprefs.getString('token');
  print("token i got ${token}");
  auth = Auth();
  if (token != "" && token !=null){
    print("token found!!!!!");
    print("token i got ${token}");
    auth.gSignin();
    _defaulthome = HomePage();
  }
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

  String username = 'not asigned';
  String token;
  SharedPreferences prefs;

  Widget build(BuildContext context) {
    // calling the functions to change the color of navigation bar and status bar
    //changeStatusColor(Colors.grey[200]);
    //changeNavigationColor(Colors.grey[200]);
    //home = trial();
    //print('build');
    //randomfunc();
    //_checklogin();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greatest app',
      home: _defaulthome,
      routes: <String, WidgetBuilder>{
        '/home' : (BuildContext context) => HomePage(),
        '/login' : (BuildContext context) => LoginPage(), 
      },
      // home: HomePage(),
    );
  }
}
