import 'dart:convert';
import 'dart:io';

import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddCourseContent extends StatefulWidget {
  @override
  _AddCourseContentState createState() => new _AddCourseContentState();
}

class _AddCourseContentState extends State<AddCourseContent> {
  final enrollController = TextEditingController();
  var _pBar;

  _makeCourseAddRequest(enrollCode) async {
    String url = DotEnv().env['API_ADDRESS'] + "/courses/register-course/";
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    final BaseAuth auth = AuthProvider.of(context).auth;
    IdTokenResult idtoken = await auth.currentUserToken();
    request.headers[HttpHeaders.authorizationHeader] = idtoken.token;
    request.body = jsonEncode({"code": enrollCode}).toString();
    client
        .send(request)
        .then((response) => response.stream.bytesToString().then((value) {
              print(value.toString());
              if (jsonDecode(value)['status'] == 'ok') {
                if (jsonDecode(value)['new'] == 'yes')
                  _showToast('Already Enrolled!');
                else
                  _showToast('Course Added!');
                Navigator.of(context).pop();
              } else {
                _showToast('Course Not Found!');
                setState(() {
                  _pBar = Container();
                });
              }
            }))
        .catchError((error) {
      print(error.toString());
      _showToast('Course Add Error!');
      setState(() {
        _pBar = Container();
      });
    });
  }

  @override
  void initState() {
    _pBar = Container();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a Course'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Enter the student enrollment code below to join a course'),
        Padding(padding: EdgeInsets.only(top: 20.0)),
        TextFormField(
          controller: enrollController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'XueVc',
              labelText: 'Enrollment Code'),
        ),
      ]),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Add Course"),
          onPressed: () {
            _makeCourseAddRequest(enrollController.text);
            setState(() {
              _pBar = CircularProgressIndicator();
            });
          },
        ),
        _pBar
      ],
    );
  }

  _showToast(text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 16.0);
  }
}
