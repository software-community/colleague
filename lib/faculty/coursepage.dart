import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'attendence_chart.dart';
import 'floating_bar.dart';
import './mark_attendence.dart';

class CourcePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CourcePage> {
  var formatter = new DateFormat('dd-MMM-yy');
  var _pages = ['26 OCT 18', '27 OCT 18', '28 OCT 18'];
  var _students = [
    ['2017csb1073', true],
    ['2017csb1073', true],
    ['2017csb1074', false],
    ['2017csb1075', false],
    ['2017csb1076', true],
    ['2017csb1077', true],
    ['2017csb1078', false],
    ['2017csb1079', true],
    ['2017csb1080', true],
    ['2017csb1081', false],
    ['2017csb1082', true],
    ['2017csb1083', true],
    ['2017csb1084', true],
    ['2017csb1085', true]
  ];
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: new Text(formatter.format(selectedDate)),
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
            Expanded(child: _MakeListTile(selectedDate, _students))
          ],
        )));
  }
}

class _MakeListTile extends StatefulWidget {
  final List _student;
  final DateTime date;
  _MakeListTile(this.date, this._student);
  @override
  _MakeList createState() => _MakeList();
}

class _MakeList extends State<_MakeListTile> {
  DateTime date;
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
          child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 120.0, 0.0),
                      child: Text(students[index][0],
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold))),
                  Switch(
                    value: students[index][1],
                    onChanged: (bool value) {
                      setState(() {
                        students[index][1] = !students[index][1];
                      });
                    },
                  )
                ],
              )),
        );
      },
    );
  }
}
