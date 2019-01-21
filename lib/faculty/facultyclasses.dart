import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../objects/allobjects.dart';
import 'package:colleague/auth.dart';
import 'add_cource.dart';
import 'package:colleague/faculty/coursepage.dart';

class FacultyClasses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FacultyClassesState();
  }
}

class _FacultyClassesState extends State<FacultyClasses> {
  // global objects
  List<Course> courses = List();
  @override
  Widget _getClassesCardFuture() {
    print("GET CLASSES CARD CALLED");
    final width = MediaQuery.of(context).size.width;
    return new FutureBuilder(
      future: getdatafromserver(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          courses.clear();
          List<Widget> allCourses = List<Widget>();
          var jsondata = jsonDecode(snapshot.data.toString());
          jsondata = jsondata[0];
          print(jsondata);
          int numcourses = jsondata["courses"].length;
          print("numcourses found...");
          for (int i = 0; i < numcourses; i++) {
            var entry = jsondata["courses"][i];
            courses.add(Course(entry["id"], entry["course__code"],
                entry["course__name"], entry["student_count"]));
          }
          for (int i = 0; i < courses.length; i++) {
            allCourses.add(Card(
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourcePage(courses[i].id)),
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
          return Text("${snapshot.error}");
        }
        return new Center(child:  CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          child: _getClassesCardFuture(),
        ));
  }

  Future<String> getdatafromserver() async {
    var url = Auth.api_address + "/accounts/api/teacher/?teacher=17";
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var outerstring;
    var jsondata;
    request.headers[HttpHeaders.AUTHORIZATION] = '1';
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    return responsestring;
  }
}
