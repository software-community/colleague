import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class PercentAttendance {
  String coursename;
  int attendance;
  PercentAttendance(this.coursename, this.attendance);
}

class AttendanceChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var data = [
      PercentAttendance('333', 90),
      PercentAttendance('345', 50),
      PercentAttendance('367', 100),
      PercentAttendance('334', 80),
      PercentAttendance('337', 70),
      PercentAttendance('327', 20),
    ];
    var series = [
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

    var chart = BarChart(
      series,
      animate: true,
    );

    var chartWidget = Padding(
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
}
