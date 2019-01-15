import 'package:flutter/material.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import '../objects/allobjects.dart';
import 'dart:convert';
import './attendancechart.dart';
import './absentlecture.dart';
import '../auth.dart';

class Classes extends StatefulWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ClassesState();
  }
}

// state for the classes statefulwidget
class _ClassesState extends State<Classes> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  var attendance;
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  Auth auth = Auth();
  double width;
  // function that returns the widget containing the list of lectures in which the person was absent
  Widget _getAbsentList(String data) {
    final widthTween = Tween<double>(begin: 0.0, end: width * .52);
    var absentclasses = <AbsentLecture>[];
    var jsondata = jsonDecode(data);
    jsondata = jsondata[0];
    var lecture_done = jsondata["lecture_done"];
    int lectureslen = lecture_done.length;
    int total = lecture_done.length + jsondata["lecture_pending"].length;
    int attended = lecture_done.length;
    for (var i = 0; i < lectureslen; i++) {
      if(lecture_done[i]["present"] == false){
        attended = attended-1;
        Lecture missed = Lecture(lecture_done[i]["id"], lecture_done[i]["lecture"], lecture_done[i]["present"], lecture_done[i]["course_id"], lecture_done[i]["code"]);
        print("this came false");
        absentclasses.add(AbsentLecture(
        missed: missed,
        animation: animation,
        widthTween: widthTween,
      ));
      }
    }
    var absenttoshow = <Widget>[];
    for (var i = 0; i < absentclasses.length; i++) {
      var absenttoAdd = absentclasses[i];
      absenttoshow.add(absenttoAdd);
      absenttoshow.add(Container(
        padding: EdgeInsets.all(2.0),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: absenttoshow,
    );
  }

  // function which returns a widget of the complete card of the attendance progress and absent lectures list
  Widget _getProgressCard(BuildContext context, String data) {
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * .015,
        vertical: width * .01,
      ),
      child: Card(
        elevation: 10.0,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .20,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: 35.0,
                  right: 30.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: SizedBox(
                  height: width * .17,
                  width: width * .17,
                  child: circleProgress(data),
                ),
              ),
              Container(
                alignment: Alignment(0.0, -0.6),
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: _getAbsentList(data),
              ),
            ]),
      ),
    );
  }

  // this function builds and returns all the class cards
  Widget _getClassesCard(BuildContext context, String data) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .22),
      margin: EdgeInsets.only(top: 4.0),
      child: Row(
        children: <Widget>[
          _buildAction(data),
          _buildAllClasses(data),
        ],
      ),
    );
  }

  Widget circleProgress(String data) {
     var jsondata = jsonDecode(data);
    jsondata = jsondata[0];
    var lecture_done = jsondata["lecture_done"];
    int lectureslen = lecture_done.length;
    int total = lecture_done.length + jsondata["lecture_pending"].length;
    int attended = lecture_done.length;
    for (var i = 0; i < lectureslen; i++) {
      if(lecture_done[i]["present"] == false){
        attended = attended-1;
      }
    }
    String missedLectureString = attended.toString() + "/" + total.toString();
    return AnimatedCircularChart(
      duration: Duration(seconds: 1),
      holeRadius: 15.0,
      key: Key('70'),
      size: Size(150.0, 150.0),
      initialChartData: <CircularStackEntry>[
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              33.33,
              Colors.blue[400],
              rankKey: 'completed',
            ),
            CircularSegmentEntry(
              66.67,
              Colors.blueGrey[600],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      percentageValues: true,
      holeLabel: missedLectureString,
      labelStyle: TextStyle(
        color: Colors.blueGrey[600],
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }

// this function returns the instance of card which holds all upcoming classes
  Widget _buildAllClasses(String data) {
    var jsondata = jsonDecode(data);
    jsondata = jsondata[0];
    var pending_lectures = jsondata["lecture_pending"];
    final courses = [];
    for(int i = 0; i < pending_lectures.length; i++){
      courses.add(pending_lectures[i]["code"]);
    }
    final timings = ['11:45 AM', '02:00 PM', '02:55 PM', '03:50 PM'];
    return Card(
      elevation: 10.0,
      child: FlipPanel.builder(
        itemsCount: 1000000000,
        period: const Duration(milliseconds: 1600),
        itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              width: width / 2 - 20,
              height: 70.0,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                      color: Colors.blue,
                    ),
                    height: 35.0,
                    width: width / 2 - 20,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        courses[index % courses.length],
                      ),
                    ),
                  ),
                  Container(
                    height: 33.0,
                    width: 150.0,
                    child: Align(
                      alignment: FractionalOffset.topCenter,
                      child: Text(
                        timings[index % courses.length],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  // this function builds and returns a single instance of the class card, it is used for showing the next class
  Widget _buildAction(String data) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        child: Card(
          elevation: 10.0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            width: width / 2 - 20,
            height: 70.0,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    color: Colors.blue,
                  ),
                  height: 35.0,
                  width: width / 2 - 20,
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Text(
                      'CSL333',
                    ),
                  ),
                ),
                Container(
                  height: 33.0,
                  width: 150.0,
                  child: Align(
                    alignment: FractionalOffset.topCenter,
                    child: Text(
                      '11:45PM',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // widget for the top card which shows the progress bar and the Alerts
    return new FutureBuilder(
      future: getdatafromserver(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Material(
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
            child: ListView(
              children: <Widget>[
                _getProgressCard(context,snapshot.data.toString()),
                _getClassesCard(context, snapshot.data.toString()),
                AttendanceChart(snapshot.data.toString()),
              ],
            ),
          );
        }else if(snapshot.hasError){
          return Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      },
    );
  }
  Future<String> getdatafromserver() async {
    var url = "http://192.168.43.203:8000/accounts/api/student/?student=9";
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
