import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'floating_bar.dart';
import 'page2.dart';
import 'package:colleague/auth.dart';

class CourcePage extends StatefulWidget {
  final int _id;
  CourcePage(this._id);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CourcePage> {
  var _formatter = new DateFormat('dd-MMM-yy');
  var _courseName = "CS201";
  var _attendenceWidget;
  List _students = [
    ['2017csb1073', true],
    ['2017csb1073', true],
    ['2017csb1074', false],
    ['2017csb1075', false],
    ['2017csb1076', true],
  ];

  DateTime selectedDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _attendenceWidget = _showAtendence(selectedDate);
      });
    print("this is also meesed up");
  }

  _showAtendence(date) {
    return FutureBuilder(
        future: getdatafromserver(widget._id.toString(), date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _students.clear();
            var jsondata = jsonDecode(snapshot.data.toString());

            iter(student, present) {
              if (student != 'time') _students.add([student, present]);
            }

            if(jsondata.length>0)
              jsondata[0].forEach(iter);

            if (_students.length > 0) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _students.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(_students[index][0],
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold)),
                            Switch(
                              value: _students[index][1],
                              onChanged: (bool value) {
                                setState(() {
                                  _students[index][1] = !_students[index][1];
                                });
                              },
                            )
                          ],
                        )),
                  );
                },
              );
            }
            else
              return Center(child: Text('no data received'),);
          }
          return new Center(child: CircularProgressIndicator());
        });
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
    _attendenceWidget = _showAtendence(selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_courseName)),
        floatingActionButton: FancyFab(), //----floating button
        body: Container(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: new Text(_formatter.format(selectedDate)),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) =>
                                ShowImage(selectedDate)));
                  },
                  child: new Text("See Images"),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) =>
                                Page2(selectedDate, _courseName)));
                  },
                  child: new Icon(Icons.insert_chart),
                )
              ],
            ),
            Expanded(child: _attendenceWidget)
          ],
        )));
  }

  Future<String> getdatafromserver(String courseid, DateTime date) async {
    final _formatter = new DateFormat('yyyy-MM-dd');
    var url = Auth.api_address +
        "/courses/get-attendance/?course_id=" +
        courseid +
        "&date=" +
        _formatter.format(date);
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    request.headers[HttpHeaders.AUTHORIZATION] = token;
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    return responsestring;
  }
}

class ShowImage extends StatelessWidget {
  final _formatter = new DateFormat('dd-MMM-yy');
  final DateTime date;
  ShowImage(this.date);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pics of " + _formatter.format(date)),
                      OutlineButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close),
                      )
                    ])),
            Hero(
              tag: "hero1",
              child: Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Image.asset(
                      "graphics/1.png",
                    ),
                  )),
            ),
            Hero(
              tag: "hero2",
              child: Container(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Image.asset(
                      "graphics/2.png",
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
