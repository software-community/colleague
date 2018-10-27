import 'package:flutter/material.dart';

import './absentlecture.dart';
import './auth.dart';
import './attendancechart.dart';
class Classes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ClassesState();
  }
}

// state for the classes statefulwidget
class _ClassesState extends State<Classes> {
  Auth auth = Auth();
  // function that returns the widget containing the list of lectures in which the person was absent
  List<Widget> _getAbsentList() {
    var absentclasses = <AbsentLecture>[];
    for (var i = 0; i < 3; i++) {
      absentclasses.add(AbsentLecture(lectureID: 3, studentID: 3));
    }
    var absenttoshow = <Widget>[];
    for (var i = 0; i < absentclasses.length; i++) {
      var absenttoAdd = absentclasses[i];
      absenttoshow.add(absenttoAdd);
      absenttoshow.add(Container(padding: EdgeInsets.all(2.0),));
    }
    return absenttoshow;
  }

  // function which returns a widget of the complete card of the attendance progress and absent lectures list
  Widget _getProgressCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          Container(
            height: 150.0,
            alignment: Alignment(0.0, -0.2),
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                strokeWidth: 25.0,
                value: 0.7,
              ),
            ),
          ),
          Container(
            alignment: Alignment(0.0, -0.6),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _getAbsentList(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text('LOGOUT'),
              onPressed: (){
                auth.gLogout().then((result){
                  if(result){
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                });
              },
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // widget for the top card which shows the progress bar and the Alerts
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _getProgressCard(context),
          //AttendanceChart(1),
          
        ],
      ),
    );
  }
}
