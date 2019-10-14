import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:colleague/auth/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './student/profile.dart';
import 'package:flutter/services.dart';
import 'camera.dart';
import 'package:camera/camera.dart';

void main() async {
  await DotEnv().load('.env');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  List<CameraDescription> cameras = await availableCameras();
  runApp(MyApp(cameras));
}

class MyApp extends StatefulWidget {
  final List<CameraDescription> cameras;
  MyApp(this.cameras);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Greatest app',
          home: RootPage(),
          routes: <String, WidgetBuilder>{
            '/camera': (BuildContext context) => Camera(widget.cameras),
            '/profile': (BuildContext context) => Profile(),
          },
        ));
  }
}
