import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class PercentAttendance {
  String coursename;
  int attendance;
  PercentAttendance(this.coursename, this.attendance);
}

class AttendanceChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AttendanceChartState();
  }
}

class AttendanceChartState extends State<AttendanceChart> {
  var amount = 60;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatafromserver();
  }

  @override
  Widget build(BuildContext context) {
    // api call to get the attendance in each course
    // TODO: implement build
    var data;
    var series;
    var chart;
    var chartWidget;
    data = [
      PercentAttendance('333', amount),
      PercentAttendance('345', 50),
      PercentAttendance('367', 100),
      PercentAttendance('334', 80),
      PercentAttendance('337', 70),
      PercentAttendance('327', 20),
    ];
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
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 10.0,
      child: chartWidget,
    );
  }

  Future<Null> getdatafromserver() async {
    var url = "http://192.168.43.203:8000/accounts/api/student/?student=9";
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var outerstring;
    var jsondata;
    request.headers[HttpHeaders.AUTHORIZATION] = '1';
    var response = await client.send(request);
    var responsestring = await response.stream.bytesToString();
    print("PRINTING RESPONSE STRING");
    jsondata = jsonDecode(responsestring.substring(1, responsestring.length-1));
    print("jsondata of student");
    print(jsondata["student"]);
    setState(() {
      amount = jsondata["student"];
    });

    print('this is the outer string');
    print(outerstring);
  }
}
