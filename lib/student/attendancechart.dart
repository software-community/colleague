import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class PercentAttendance {
  String coursename;
  double attendance;
  PercentAttendance(this.coursename, this.attendance);
  void setdata(String newname, double newattendance){
    this.coursename = newname;
    this.attendance = newattendance;
  } 
}

class AttendanceChart extends StatefulWidget {
  String serverdata;
  AttendanceChart(this.serverdata);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AttendanceChartState();
  }
}

class AttendanceChartState extends State<AttendanceChart> {
  double amount = 60;
  List<PercentAttendance> data = List();
  var chartWidget;
  var chart;
  var series;
  var toreturn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // api call to get the attendance in each course
    // TODO: implement build
    var jsondata = jsonDecode(widget.serverdata);
    jsondata = jsondata[0];
    var allcourses = jsondata["courses"];
    for (int i = 0; i < allcourses.length; i++){
      data.add(PercentAttendance(allcourses[i]["code"], allcourses[i]["attendance"]));
    }

    series = [
      Series(
        id: 'Attendance',
        domainFn: (PercentAttendance attchart, _) => attchart.coursename,
        measureFn: (PercentAttendance attchart, _) => attchart.attendance,
        colorFn: (PercentAttendance attchart, _) => Color(
              r: Colors.grey[700].red,
              g: Colors.grey[700].green,
              b: Colors.grey[700].blue,
              a: Colors.grey[700].alpha,
            ),
        data: data,
      ),
    ];
    chart = BarChart(
      series,
      animate: true,
    );

    chartWidget = Padding(
      padding: EdgeInsets.all(25.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    toreturn = Card(
      margin: EdgeInsets.all(10.0),
      elevation: 10.0,
      child: chartWidget,
    );
    return toreturn;
  }
}
