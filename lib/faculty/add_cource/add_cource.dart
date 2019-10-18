import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'add_course_dialogue.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourse createState() => _AddCourse();
}

class _AddCourse extends State<AddCourse> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var lectures = {
    "monday": [],
    "tuesday": [],
    "wednesday": [],
    "thursday": [],
    "friday": [],
  };
  var lts;
  var _pBar;
  String _courseCode;
  String _courseName;
  String selectedDay;
  List _maptoList() {
    List lts = [];
    void f(day, timings) {
      for (var timing in timings) lts.add([day.toString(), timing]);
    }

    lectures.forEach(f);
    return lts;
  }

  Map<String, dynamic> _listtoMap() {
    Map<String, dynamic> datatoSend = {
      "course_code": _courseCode,
      "course_name": _courseName,
      "lectures": {
        "monday": [],
        "tuesday": [],
        "wednesday": [],
        "thursday": [],
        "friday": [],
      }
    };
    for (var lec in lts) {
      datatoSend['lectures'][lec[0]].add(lec[1]);
    }
    return datatoSend;
  }

  void _showDialog(day) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return MyDialogContent(onAdd: (List startEnd) {
          setState(() {
            lts.add([
              day,
              {
                "start_time": startEnd[0],
                "end_time": startEnd[1],
              }
            ]);
          });
        });
      },
    );
  }

  _postdata() {
    _formKey.currentState.save();
    if (_courseCode != "" && _courseName != "") {
      Map<String, dynamic> data = _listtoMap();
      print(data);
      setState(() {
        _pBar = _progressbar();
      });
      _apiRequest(DotEnv().env['API_ADDRESS'] + "/courses/add-courses/", data);
    }
  }

  _apiRequest(String url, Map<String, dynamic> jsonData) async {
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    BaseAuth auth = AuthProvider.of(context).auth;
    IdTokenResult idTokenResult = await auth.currentUserToken();
    request.headers[HttpHeaders.acceptHeader] = idTokenResult.token;
    request.body = jsonEncode(jsonData).toString();
    client
        .send(request)
        .then((response) => response.stream
            .bytesToString()
            .then((value) => print(value.toString())))
        .catchError((error) => print(error.toString()))
        .whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    lts = _maptoList();
    _courseCode = "";
    _courseName = "";
    selectedDay = "monday";
    _pBar = Stack();
    super.initState();
  }

  _progressbar() {
    return new Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Course"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                _postdata();
              },
            )
          ],
        ),
        body: Stack(children: <Widget>[
          ListView(children: [
            Form(
                key: _formKey,
                child: FormCard(
                  children: <Widget>[
                    Text("Course Details"),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (String value) {
                          _courseCode = value;
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'CS201',
                            labelText: 'Course Code')),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (String value) {
                          _courseName = value;
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Data Structure',
                            labelText: 'Course Name')),
                  ],
                )),
            FormCard(
              children: <Widget>[
                Text("Lectures"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: selectedDay,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          child: Text('Monday'),
                          value: 'monday',
                        ),
                        DropdownMenuItem(
                            child: Text('Tuesday'), value: 'tuesday'),
                        DropdownMenuItem(
                            child: Text('Wednesday'), value: 'wednesday'),
                        DropdownMenuItem(
                            child: Text('Thursday'), value: 'thursday'),
                        DropdownMenuItem(
                            child: Text('Friday'), value: 'friday'),
                      ],
                      onChanged: (String value) {
                        setState(() {
                          selectedDay = value;
                        });
                      },
                    ),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0)),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () {
                        _showDialog(selectedDay);
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    height: 250.0,
                    child: ListView.builder(
                      itemCount: lts.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Card(
                            child: Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        lts[index][0].toUpperCase() +
                                            " : " +
                                            lts[index][1]['start_time'] +
                                            "-" +
                                            lts[index][1]['end_time'],
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            lts.removeAt(index);
                                          });
                                        },
                                        child:
                                            Icon(Icons.remove_circle_outline),
                                      )
                                    ])));
                      },
                    ))
              ],
            )
          ]),
          _pBar,
        ]));
  }
}

class FormCard extends StatelessWidget {
  const FormCard({this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 12.0, bottom: 18.0),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
