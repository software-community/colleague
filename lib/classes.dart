import 'package:flutter/material.dart';
import 'package:flip_panel/flip_panel.dart';

import './attendancechart.dart';
import './absentlecture.dart';
import './auth.dart';

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
  double width;
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
      absenttoshow.add(Container(
        padding: EdgeInsets.all(2.0),
      ));
    }
    return absenttoshow;
  }

  // function which returns a widget of the complete card of the attendance progress and absent lectures list
  Widget _getProgressCard(BuildContext context) {
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
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                    strokeWidth: width * .1,
                    value: 0.7,
                  ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _getAbsentList(),
                ),
              ),
              /*
              Container(
                padding: EdgeInsets.all(0.0),
                child: FlatButton(
                  child: Text('LOGOUT'),
                  onPressed: () {
                    auth.gLogout().then((result) {
                      if (result) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    });
                  },
                ),
              ),*/
            ]),
      ),
    );
  }

  // this function builds and returns all the class cards
  Widget _getClassesCard(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .22),
      margin: EdgeInsets.only(top: 4.0),
      child: Row(
        children: <Widget>[
          _buildAction('Class1'),
          _buildAllClasses(),
        ],
      ),
    );
  }

  Widget _buildAllClasses() {
    final courses = ['CSL456', 'CSL503', 'PHL201', 'MAL112'];
    final timings = ['11:45 AM', '02:00 PM', '02:55 PM', '03:50 PM'];
    return Card(
        elevation: 10.0,
        child: FlipPanel.builder(
          itemsCount: 1000000000,
          period: const Duration(milliseconds: 1600),
          itemBuilder:(context, index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
              width: width / 2 - 20,
              height: 120.0,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: width / 2 - 20,
                    color: Colors.blue,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        courses[index%4],
                      ),
                    ),
                  ),
                  Container(
                    height: 58.0,
                    width: 150.0,
                    child: Align(
                      alignment: FractionalOffset.topCenter,
                      child: Text(
                        timings[index%4],
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  // this function builds and returns a single instance of the class card
  Widget _buildAction(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Card(
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              width: width / 2 - 20,
              height: 120.0,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: width / 2 - 20,
                    color: Colors.blue,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        'CSL333',
                      ),
                    ),
                  ),
                  Container(
                    height: 58.0,
                    width: 150.0,
                    child: Align(
                      alignment: FractionalOffset.topCenter,
                      child: Text(
                        '10:45 AM',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // widget for the top card which shows the progress bar and the Alerts
    return Container(
      child: ListView(
        children: <Widget>[
          _getProgressCard(context),
          _getClassesCard(context),
          AttendanceChart(),
        ],
      ),
    );
  }
}
