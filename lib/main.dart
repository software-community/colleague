import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:backdrop/backdrop.dart';

import './auth.dart';
import './login.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import './student/studenthome.dart';
import './faculty/facultyhome.dart';
import './faculty/coursepage.dart';
import 'camera.dart';
import 'package:camera/camera.dart';

SharedPreferences myprefs;
Widget _defaulthome;
Auth auth = Auth();
void main() async{
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  List<CameraDescription> cameras = await availableCameras();
  _defaulthome = LoginPage();
  myprefs = await SharedPreferences.getInstance();
  String token = myprefs.getString('token');
  print("token i got ${token}");
  auth = Auth();
  if (token != "" && token !=null){
    print("token found!!!!!");
    print("token i got ${token}");
    if(token == '1') {
      _defaulthome = StudentHome(0);
    }
    if(token == '2'){
      _defaulthome = FacultyHome(0);
    }
  }
  runApp(MyApp(cameras));
}

class MyApp extends StatefulWidget {
  List<CameraDescription> cameras;
  MyApp(this.cameras);
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
        '/facultyhome' : (BuildContext context) => FacultyHome(0),
        '/studenthome' : (BuildContext context) => StudentHome(0),
        '/tastudenthome' : (BuildContext context) => StudentHome(1),
        '/tahome' : (BuildContext context) => FacultyHome(1),
        '/login' : (BuildContext context) => LoginPage(), 
        '/camera' : (BuildContext context) => Camera(widget.cameras),
      },
      // home: HomePage(),
    );
  }
}