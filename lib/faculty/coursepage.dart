import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'floating_bar.dart';

class CourcePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CourcePage> {
  var _formatter = new DateFormat('dd-MMM-yy');
  List _students = [
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

  DateTime selectedDate;

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

  _showAtendence() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _students.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 120.0, 0.0),
                      child: Text(_students[index][0],
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold))),
                  Switch(
                    value: _students[index][1],
                    onChanged: (bool value) {
                      setState(() {
                        _students[index][1] = !_students[index][1];
                      });
                    },
                  )
                ],
              )),
        );
      },
    );
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
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
                  child: new Text(_formatter.format(selectedDate)),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) => ShowImage(selectedDate)));
                  },
                  child: new Text("See Images"),
                )
              ],
            ),
            Expanded(child: _showAtendence())
          ],
        )));
  }
}

class ShowImage extends StatelessWidget {
  final _formatter = new DateFormat('dd-MMM-yy');
  final DateTime date;
  ShowImage(this.date);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[ 
                  Text("Pics of "+_formatter.format(date)),
                  OutlineButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close),
                )])),
            Hero(
              tag: "hero1",
              child: Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Image.asset(
                      "graphics/1.png",
                    ),
                  )),
            ),
            Hero(
              tag: "hero2",
              child: Container(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Image.asset(
                      "graphics/2.png",
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
