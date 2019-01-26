import 'package:flutter/material.dart';

import 'attendence_chart.dart';

class Page2 extends StatefulWidget {
  final String _id;
  final String _courceName;
  Page2(this._id,this._courceName);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page2> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget._courceName)),
        body: ListView(
            children: [AttendanceChart(widget._id),
        ]));
  }
}
