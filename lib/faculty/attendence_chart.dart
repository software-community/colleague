import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class PercentAttendance {
  String coursename;
  int attendance;
  PercentAttendance(this.coursename, this.attendance);
}

class AttendanceChart extends StatefulWidget {
 final String _date;
  AttendanceChart(this._date);
  @override
  _AttendenceState createState() => _AttendenceState();
}

class _AttendenceState extends State<AttendanceChart> {
  String _date;
  String _value = 'one';
  var _below75;
  var _showdata;
  var data = [
    PercentAttendance('2017csb1073', 90),
    PercentAttendance('2017csb1074', 85),
    PercentAttendance('2017csb1075', 65),
    PercentAttendance('2017csb1076', 78),
    PercentAttendance('345', 50),
    PercentAttendance('367', 100),
    PercentAttendance('334', 70),
    PercentAttendance('354', 80),
    PercentAttendance('335', 80),
    PercentAttendance('3348', 80),
    PercentAttendance('3344', 80),
    PercentAttendance('3345', 80),
    PercentAttendance('3346', 80),
    PercentAttendance('3347', 80),
  ];

  @override
  void initState() {
    _date=widget._date;
    _below75 = data.where((i) => i.attendance < 75).toList();
    _showdata=data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var series = [
      Series(
        id: 'Attendance',
        domainFn: (PercentAttendance attchart, _) => attchart.coursename,
        measureFn: (PercentAttendance attchart, _) => attchart.attendance,
        labelAccessorFn: (PercentAttendance attchart, _) =>
            '${attchart.coursename}: ${attchart.attendance.toString()}%',
        fillColorFn: (PercentAttendance attchart, _) {
          if (attchart.attendance < 75)
            return MaterialPalette.red.shadeDefault;
          else if (attchart.attendance <= 80)
            return MaterialPalette.blue.shadeDefault;
          else
            return MaterialPalette.green.shadeDefault;
        },
        data: _showdata,
      ),
    ];

    var chartWidget = Padding(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      child: SizedBox(
        child: BarChart(
          series,
          animate: true,
          vertical: false,
          barRendererDecorator: new BarLabelDecorator<String>(),
          // Hide domain axis.
          domainAxis: OrdinalAxisSpec(renderSpec: new NoneRenderSpec()),
        ),
        height: 40.0 * _showdata.length,
      ),
    );

    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        child: Column(children: [
          DropdownButton<String>(
            value: _value,
            items: <DropdownMenuItem<String>>[
              new DropdownMenuItem(
                child: new Text('All'),
                value: 'one',
              ),
              new DropdownMenuItem(child: new Text('Below 75%'), value: 'two'),
            ],
            onChanged: (String value) {
              setState(() {
                _value = value;
                if (value == 'two') {
                  _showdata = _below75;
                } else
                  _showdata = data;
              });
            },
          ),
          chartWidget
        ]));
  }
}
