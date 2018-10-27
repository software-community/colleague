import './main.dart';
import 'package:flutter/material.dart';
import './auth.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Auth auth = Auth();
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return MaterialApp(
        home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Google-Signin'),
                onPressed: () {
                  auth.gSignin().then((result){
                    if(result){
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  });
                },
                color: Colors.red[900],
              ),
            ],
          ),
        ),
      ),
    );
  }
}