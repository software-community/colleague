import './main.dart';
import 'package:flutter/material.dart';
import './auth.dart';
import 'faculty/facultyhome.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // This is the class for the login page. This class loads the google signin page at the start of the app.
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
              // a flat button for google signin
              FlatButton(
                child: Text('Google-Signin'),
                onPressed: () {
                  auth.gSignin().then((result) {
                    // the result is the pass variable returned from the login method in auth class
                    if (result[1] > 0) {
                      if (result[1] == 3) {
                        Navigator.of(context)
                            .pushReplacementNamed('/tastudenthome');
                      }
                      if (result[1] == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FacultyHome(0,result[0])),
                        );
                      }
                      if (result[1] == 1) {
                        Navigator.of(context)
                            .pushReplacementNamed('/studenthome');
                      }
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
