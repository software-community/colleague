import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import '../objects/allobjects.dart';
import 'dart:convert';

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
      builder: (context, snapshot){
        if(snapshot.hasData){
          courses.clear();
          List<Widget> allCourses = List<Widget>();
          var jsondata = jsonDecode(snapshot.data.toString());
          jsondata = jsondata[0];
          print(jsondata);
          int numcourses = jsondata["courses"].length;
          print("numcourses found...");
          for(int i=0; i<numcourses; i++){
            var entry = jsondata["courses"][i];
            courses.add(Course(entry["id"], entry["course__code"], entry["course__name"], entry["student_count"]));

          }
          for (int i = 0; i < courses.length; i++) {
            allCourses.add(Card(
              margin: EdgeInsets.symmetric(
                horizontal: width * .015,
                vertical: width * .01,
              ),
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  print("tapped");
                  Navigator.pushNamed(context, '/course');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(courses[i].course_code),
                    )
                  ],
                ),
              ),
            ));
          }
          return ListView(
            children: allCourses,
          );
        }else if(snapshot.hasError){
          return Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
      child: _getClassesCardFuture(),
    );
  }
  
  Future<String> getdatafromserver() async {
    var url = "http://192.168.43.203:8000/accounts/api/teacher/?teacher=10";
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
