import 'package:flutter/material.dart';

import 'attendence_chart.dart';

class Page2 extends StatefulWidget {
  final DateTime date;
  final String _courseName;
  Page2(this.date,this._courseName);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page2> {
  DateTime _curdate;
  String _courseName;

  @override
  void initState() {
    _curdate = widget.date;
    _courseName=widget._courseName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_courseName)),
        body: ListView(
            children: [AttendanceChart(_curdate),
        ]));
  }
}
