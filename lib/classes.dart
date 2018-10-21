import 'package:flutter/material.dart';

import './absentlecture.dart';

class Classes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ClassesState();
  }
}

class _ClassesState extends State<Classes> {
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

  @override
  Widget build(BuildContext context) {
    // widget for the top card which shows the progress bar and the Alerts
    var classcard = Padding(
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
        ]),
      ),
    );
    return classcard;
  }
}
