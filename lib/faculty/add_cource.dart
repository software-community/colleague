import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:colleague/auth.dart';

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
      print("before datatosubmit");
      Map<String, dynamic> data = _listtoMap();
      print("DATA TO SUBMIT");
      print(data);
      setState(() {
        _pBar = _progressbar();
      });
      apiRequest(Auth.api_address + "/courses/add-courses/", data);
    }
  }

  Future<void> apiRequest(String url, Map<String, dynamic> jsonData) async {
    print("entered api request");
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    //Map<String, dynamic> body = jsonDecode(jsonData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print(token);
    request.headers[HttpHeaders.AUTHORIZATION] = token;
    request.body = jsonEncode(jsonData).toString();
    var future = client
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
    // TODO: implement initState
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

class MyDialogContent extends StatefulWidget {
  final ValueChanged<List<String>> onAdd;
  MyDialogContent({this.onAdd});
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  @override
  void initState() {
    startTime = TimeOfDay(hour: 9, minute: 0);
    endTime = TimeOfDay(hour: 9, minute: 50);
    super.initState();
  }

  Future<void> _selectTime(BuildContext context, int time) async {
    if (time == 0) {
      final TimeOfDay picked =
          await showTimePicker(context: context, initialTime: startTime);
      if (picked != null && picked != startTime)
        setState(() {
          startTime = picked;
        });
    } else {
      final TimeOfDay picked =
          await showTimePicker(context: context, initialTime: endTime);
      if (picked != null && picked != endTime)
        setState(() {
          endTime = picked;
        });
    }
  }

  var startTime;
  var endTime;

  _getContent() {
    return Container(
        height: 100.0,
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Start Time : "),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _selectTime(context, 0);
                    });
                  },
                  child: Text(startTime.format(context)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("End Time : "),
                RaisedButton(
                  onPressed: () {
                    _selectTime(context, 1);
                  },
                  child: Text(endTime.format(context)),
                )
              ],
            ),
          ],
        ));
  }

  String format(BuildContext context, TimeOfDay t) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      t,
      alwaysUse24HourFormat: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Create Lecture"),
      content: _getContent(),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(100.0)),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () {
            widget
                .onAdd([format(context, startTime), format(context, endTime)]);
            Navigator.of(context).pop();
          },
          child: Text("ADD"),
        ),
      ],
    );
  }
}
