import 'package:flutter/material.dart';

import 'attendence_chart.dart';
import 'floating_bar.dart';

class CourcePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('CS201'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Air it',
              onPressed: () {},
              alignment: Alignment.centerLeft),
          Container(
            child: Text(
              '26 OCT 18',
              style: TextStyle(fontSize: 17.0),
            ),
            alignment: Alignment.center,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            tooltip: 'Air it',
            onPressed: () {},
            alignment: Alignment.centerRight,
          ),
        ],
      ),
      floatingActionButton: FancyFab(), //----floating button
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 1)
              return AttendanceChart();
            else
              return Card(
                elevation: 8.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.lightBlue[800]),
                  child: _MakeListTile('Mark/Change Attendence', 0xe150),
                ),
              );
          },
        ),
      ),
    ));
  }
}

class _MakeListTile extends StatelessWidget {
  final String text;
  final int icon;
  _MakeListTile(this.text, this.icon);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        leading: Container(
          padding: EdgeInsets.only(right: 15.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(IconData(icon, fontFamily: 'MaterialIcons'),
              color: Colors.white),
        ),
        title: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 40.0));
  }
}
