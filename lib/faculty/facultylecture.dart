import 'package:flutter/material.dart';
import 'package:colleague/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../objects/allobjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FacultyLectures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FacultyLecturesState();
  }
}

class _FacultyLecturesState extends State<FacultyLectures> {
  List<LectureProff> lectures = List();
  List<Widget> allLectures = List<Widget>();
  Widget _getLecturesCard() {
    final width = MediaQuery.of(context).size.width;
    List type = ['Lab', 'Lecture', 'Lab', 'Lecture'];
    List numS = ['67', '43', '23', '54'];
    List time = ['10:45 AM', '10:45 AM', '10:45 AM', '10:45 AM'];
    return new FutureBuilder(
      future: _getdatafromserver(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lectures.clear();
          var jsondata = jsonDecode(snapshot.data.toString());
          jsondata = jsondata[0];
          print(jsondata);
          int numlectures = jsondata["lecture_pending"].length;
          for (int i = 0; i < numlectures; i++) {
            var lect = jsondata["lecture_pending"][i];
            print("ABOUT TO ADD LECTURE");
            lectures.add(LectureProff(
                lect["id"], lect["course"], lect["time"], lect["code"]));
            print("CREATED LECTURE");
            allLectures.add(Card(
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Cancel Lecture"),
                          content: Text(
                              "You have this lecture coming soon, do you want to cancel this lecture?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Yes Cancel"),
                              onPressed: () {
                                _deleteLecture(lectures[i].id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
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
                            lectures[i].code,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            type[i],
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
                            Text(lectures[i].time.substring(0, 5)),
                            Container(
                              child: Row(children: <Widget>[
                                Text(numS[i]),
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
            children: allLectures,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      },
    );
  }

  Future<String> _deleteLecture(int lectureID) async {
    var url = Auth.api_address+"/lectures/api/lecture/"+lectureID.toString()+"/";
    var client = http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var request = http.Request('DELETE', Uri.parse(url));
    var outerstring;
    var jsondata;
    request.headers[HttpHeaders.AUTHORIZATION] = token;
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    print("DELETE RESPONSE");
    print(responsestring);
    
  }

  Future<String> _getdatafromserver() async {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
      child: Scaffold(
        body: _getLecturesCard(),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.camera),
            label: Text('Snap'),
            elevation: 20.0,
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            }),
      ),
    );
  }
}
