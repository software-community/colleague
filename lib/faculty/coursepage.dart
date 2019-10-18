import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'floating_bar.dart';
import 'page2.dart';

class CourcePage extends StatefulWidget {
  final int _id;
  final String _courseName;
  final String studentCode;
  final String taCode;
  CourcePage(this._id, this._courseName, this.studentCode, this.taCode);
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CourcePage> with TickerProviderStateMixin {
  var _formatter = new DateFormat('dd-MMM-yy');
  var _attendenceWidget;
  TabController _tabController;
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
        future: getdatafromserver('15', date),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var jsondata = jsonDecode(snapshot.data.toString());

            List<List> _students = List();

            List<Widget> tabs = List();
            if (jsondata.length > 0) {
              for (int i = 0; i < jsondata.length; i++) {
                _students.add(List());
                iter(student, value) {
                  if (student != 'time')
                    _students[i].add([student, value[0], value[1]]);
                }

                jsondata[i].forEach(iter);
              }

              _tabController =
                  new TabController(vsync: this, length: jsondata.length);

              for (int index = 0; index < jsondata.length; index++) {
                tabs.add(Tab(
                  child: Text(
                    jsondata[index]['time'],
                    style: TextStyle(color: Colors.black),
                  ),
                ));
              }
            }

            if (_students.length > 0) {
              List<Widget> studentsWidgets = List();
              for (int i = 0; i < _students.length; i++) {
                studentsWidgets.add(ListView.builder(
                  itemCount: _students[i].length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(_students[i][index][0],
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                              Switch(
                                value: _students[i][index][1],
                                onChanged: (bool _value) {
                                  print(_value);
                                  setState(() {
                                    _students[i][index][1] = _value;
                                  });
                                  set_att(_students[i][index][2], _value);
                                },
                              )
                            ],
                          )),
                    );
                  },
                ));
              }
              return Column(
                children: <Widget>[
                  PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child: new Container(
                        height: 50.0,
                        child: new TabBar(
                          controller: _tabController,
                          tabs: tabs,
                        ),
                      )),
                  Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          children: studentsWidgets))
                ],
              );
            } else
              return Center(
                child: Text('no data received'),
              );
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

  void showMenuSelection(String value) {
    if (value == "code")
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Code to join"),
              content: Text("Student Code : " +
                  widget.studentCode +
                  "\nTA Code : " +
                  widget.taCode),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._courseName),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: showMenuSelection,
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                      const PopupMenuItem<String>(
                        value: 'code',
                        child: Text('Student/TA Code'),
                      ),
                    ])
          ],
        ),
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
                            builder: (BuildContext context) => Page2(
                                widget._id.toString(), widget._courseName)));
                  },
                  child: new Icon(Icons.insert_chart),
                )
              ],
            ),
            Expanded(
              child: _attendenceWidget,
            )
          ],
        )));
  }

  Future<String> getdatafromserver(String courseid, DateTime date) async {
    final _formatter = new DateFormat('yyyy-MM-dd');
    var url = DotEnv().env['API_ADDRESS'] +
        "/courses/get-attendance/?course_id=" +
        courseid +
        "&date=" +
        _formatter.format(date);
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    request.headers[HttpHeaders.userAgentHeader] = token;
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    print(responsestring);
    return responsestring;
  }

  Future set_att(id, present) async {
    var url = DotEnv().env['API_ADDRESS'] +
        "/lectures/api/sal/" +
        id.toString() +
        "/";

    var request = new http.MultipartRequest("PATCH", Uri.parse(url));
    request.fields["present"] = present.toString();
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
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
