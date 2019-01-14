import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:colleague/auth.dart';

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
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AttendanceChartState();
  }
}

class AttendanceChartState extends State<AttendanceChart> {
  double amount = 60.0;
  List<PercentAttendance> data = List();
  var chartWidget;
  var chart;
  var series;
  var toreturn;
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
    data.add(PercentAttendance('', 0.0));
    data.add(PercentAttendance('', 0.0));
    data.add(PercentAttendance('', 0.0));
    data.add(PercentAttendance('', 0.0));
    data.add(PercentAttendance('', 0.0));
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

  Future<Null> getdatafromserver() async {
    var url = Auth.api_address+"/accounts/api/student/?student=9";
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
      int numcourses = jsondata["courses"].length;
      for(int i=0; i<numcourses; i++){
        data[i] = PercentAttendance(jsondata["courses"][i]["id"].toString(), jsondata["courses"][i]["attendace"]*100);
        print(data);
      }
    });

    print('this is the outer string');
    print(outerstring);
  }
}
