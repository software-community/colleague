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
  String _curdate;

  @override
  void initState() {
    _curdate = _pages[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _curdate,
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
              child: PageView.builder(
            onPageChanged: (int index) {
              setState(() {
                _curdate = _pages[index];
              });
            },
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              return _Pagecontaint(_pages[index]);
            },
          )),
        );
  }
}

class _Pagecontaint extends StatelessWidget {
  final String _date;
  _Pagecontaint(this._date);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 1)
          return AttendanceChart(_date);
        else
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.lightBlue[800]),
              child: _MakeListTile('Mark/Change Attendence', 0xe150),
            ),
          );
      },
    );
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
        title: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MarkAttendence()),);
            },
            child: Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 40.0));
  }
}
