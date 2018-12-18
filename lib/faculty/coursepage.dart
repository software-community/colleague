import 'package:flutter/material.dart';

import 'attendence_chart.dart';
import 'floating_bar.dart';
import './mark_attendence.dart';

class CourcePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CourcePage> {
  var _pages = ['26 OCT 18', '27 OCT 18', '28 OCT 18'];
  var _students = [
    ['2017\n csb\n1073', true],
    ['73', true],
    ['74', false],
    ['75', false],
    ['76', true],
    ['77', true],
    ['78', false],
    ['79', true],
    ['80', true],
    ['81', false],
    ['82', true],
    ['83', true],
    ['84', true],
    ['85', true]
  ];
  String _curdate;

  @override
  void initState() {
    _curdate = _pages[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('CS201')),
        floatingActionButton: FancyFab(), //----floating button
        body: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  
                  children: [
                    RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () {},
                      child: new Text("26 OCT 18"),
                    ),
                    RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () {},
                      child: new Text("See Images"),
                    )
                  ],
                ),
                Expanded(
                     child: _MakeListTile("26 OCT 18", _students))
              ],
            )));
  }
}

class _MakeListTile extends StatefulWidget {
  var _student;
  String date;
  _MakeListTile(this.date, this._student);
  @override
  _MakeList createState() => _MakeList();
}

class _MakeList extends State<_MakeListTile> {
  String date;
  List students;
  @override
  void initState() {
    date = widget.date;
    students = widget._student;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: students.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Row(
            children: <Widget>[
              Text(students[index][0]),
              new Switch(
                value: students[index][1],
                onChanged: (bool value) {
                  setState(() {
                    students[index][1] = !students[index][1];
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }
}
