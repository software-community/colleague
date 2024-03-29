import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../objects/allobjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyLectures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FacultyLecturesState();
  }
}

class _FacultyLecturesState extends State<FacultyLectures> {
  var _body;

  Widget _getLecturesCard() {
    return new FutureBuilder(
      future: _getdatafromserver(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          var jsondata;
          try {
            jsondata = snapshot.data[0]['lecture_pending'];
            if (jsondata.length == 0) throw Exception('No Lecture!');
          } catch (err) {
            return Center(
              child: Text("No Lecture Today!"),
            );
          }
          List<LectureProff> lectures = List();
          List<Widget> allLectures = List<Widget>();

          int numlectures = jsondata.length;
          for (int i = 0; i < numlectures; i++) {
            var lect = jsondata[i];
            lectures.add(LectureProff(
                lect["id"], lect["course"], lect["time"], lect["code"], lect['type']));
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
                              child: Text("Cancel"),
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
                            lectures[i].type.toUpperCase(),
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
          return Center(
              child: RaisedButton(
            child: Icon(Icons.replay),
            onPressed: () {
              setState(() {
                _body = _getLecturesCard();
              });
            },
          ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _deleteLecture(int lectureID) async {
    var url = DotEnv().env['API_ADDRESS'] +
        "/lectures/api/lecture/" +
        lectureID.toString() +
        "/";
    var client = http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var request = http.Request('DELETE', Uri.parse(url));
    request.headers[HttpHeaders.userAgentHeader] = token;
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    print("DELETE RESPONSE");
    print(responsestring);
  }

  @override
  void didChangeDependencies() {
    _body = _getLecturesCard();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
      child: Scaffold(
        body: _body,
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

  Future<dynamic> _getdatafromserver() async {
    final BaseAuth auth = AuthProvider.of(context).auth;
    var url =
        DotEnv().env['API_ADDRESS'] + "/accounts/api/teacher/?id=" + auth.id;
    IdTokenResult idtoken = await auth.currentUserToken();
    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: idtoken.token});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      throw Exception('Error in getting');
  }
}
