import 'package:flutter/material.dart';
import 'package:colleague/auth/auth.dart';

import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedIn;
  LoginPage({this.onSignedIn});
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // This is the class for the login page. This class loads the google signin page at the start of the app.
  bool isStudent = true;
  bool isTeacher = false;

  _getOtions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Student'),
          onPressed: () {
            setState(() {
              isStudent = true;
              isTeacher = false;
            });
          },
          color: isStudent ? Colors.blue : Colors.white,
        ),
        RaisedButton(
          child: Text('Teacher'),
          onPressed: () {
            setState(() {
              isStudent = false;
              isTeacher = true;
            });
          },
          color: isTeacher ? Colors.blue : Colors.white,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getOtions(),
              // a flat button for google signin
              FlatButton(
                child: Text('Google-Signin'),
                onPressed: () async {
                  final BaseAuth auth = AuthProvider.of(context).auth;
                  bool result = await auth.gSignIn(isStudent, isTeacher);
                  if (result) {
                    widget.onSignedIn();
                  } else {
                    Scaffold.of(context).showSnackBar(
                        new SnackBar(content: new Text('Login Error!')));
                  }
                },
                color: Colors.red[900],
              ),
            ],
          );
        }),
      ),
    );
  }
}
