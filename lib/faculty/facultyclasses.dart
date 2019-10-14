import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../objects/allobjects.dart';
import 'add_cource.dart';
import 'package:colleague/faculty/coursepage.dart';

class FacultyClasses extends StatefulWidget {
  final String id;
  FacultyClasses(this.id);
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
          print(jsondata);
          if (jsondata.length > 0) {
            jsondata = jsondata[0];
            print(jsondata);
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
          } else {
            return Center(
              child: Text("No Courses Found!"),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return new Center(child: CircularProgressIndicator());
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
    var url = DotEnv().env['API_ADDRESS'] +
        "/accounts/api/teacher/?teacher=" +
        widget.id.toString();
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var outerstring;
    var jsondata;
    request.headers[HttpHeaders.userAgentHeader] = '1';
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    return responsestring;
  }
}
