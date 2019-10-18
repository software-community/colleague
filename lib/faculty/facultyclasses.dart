import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:colleague/objects/allobjects.dart';
import 'add_cource/add_cource.dart';
import 'package:colleague/faculty/coursepage.dart';

class FacultyClasses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FacultyClassesState();
  }
}

class _FacultyClassesState extends State<FacultyClasses> {
  // global objects
  var _body;
  List<Course> courses = List();
  Widget _getClassesCardFuture() {
    return new FutureBuilder(
      future: _getdatafromserver(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<Widget> allCourses = List<Widget>();
          var jsondata = snapshot.data;
          if (jsondata.length == 0 || jsondata[0].length == 0)
            return Center(
              child: Text("No Courses Found!"),
            );

          jsondata = jsondata[0];
          int numcourses = jsondata["courses"].length;
          print("numcourses found...");
          for (int i = 0; i < numcourses; i++) {
            var entry = jsondata["courses"][i];
            courses.add(Course(
                entry["id"],
                entry["course__code"],
                entry["course__name"],
                entry["student_count"],
                entry['student_code'],
                entry['ta_code']));
          }
          for (int i = 0; i < courses.length; i++) {
            allCourses.add(Card(
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourcePage(
                            courses[i].id,
                            courses[i].course_name,
                            courses[i].studentCode,
                            courses[i].taCode)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  height: 60.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            courses[i].course_code,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            courses[i].course_name,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(children: <Widget>[
                                Text(courses[i].student_count.toString()),
                                Align(
                                  alignment: Alignment(-3.0, -4.0),
                                  child: Icon(
                                    Icons.face,
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          }
          return ListView(
            children: allCourses,
          );
        } else if (snapshot.hasError) {
          return Center(
              child: RaisedButton(
            child: Icon(Icons.replay),
            onPressed: () {
              setState(() {
                _body = _getClassesCardFuture();
              });
            },
          ));
        }
        return new Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void didChangeDependencies() {
    _body = _getClassesCardFuture();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => AddCourse()));
            }),
        body: Material(
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
          child: _body,
        ));
  }

  Future<dynamic> _getdatafromserver() async {
    final BaseAuth auth = AuthProvider.of(context).auth;
    var url = DotEnv().env['API_ADDRESS'] +
        "/accounts/api/teacher/?teacher=" +
        auth.id;
    IdTokenResult idtoken = await auth.currentUserToken();
    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: idtoken.token});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      throw Exception('Error in getting');
  }
}
