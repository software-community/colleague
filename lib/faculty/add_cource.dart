import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourse createState() => _AddCourse();
}

class _AddCourse extends State<AddCourse> {
  var lectures = {
    "monday": [
      {
        "start_time": "11:00",
        "end_time": "11:50",
      },
      {
        "start_time": "14:00",
        "end_time": "14:50",
      }
    ],
    "tuesday": [
      {
        "start_time": "10:00",
        "end_time": "10:50",
      }
    ],
    "wednesday": [],
    "thursday": [],
    "friday": [],
  };
  var lts;
  String selectedDay;
  List _map_to_list() {
    List lts = [];
    void f(day, timings) {
      for (var timing in timings) lts.add([day.toString(), timing]);
    }

    lectures.forEach(f);
    return lts;
  }

  void _showDialog(day) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return MyDialogContent(onAdd: (List startEnd) {
          setState(() {
            lts.add([
              day,
              {
                "start_time": startEnd[0],
                "end_time": startEnd[1],
              }
            ]);
          });
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    lts = _map_to_list();
    selectedDay = "Monday";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add Course")),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: ListView(children: [
            FormCard(
              children: <Widget>[
                Text("Course Details"),
                TextFormField(
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'CS201', labelText: 'Course Code')),
                new TextFormField(
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Data Structure', labelText: 'Course Name')),
              ],
            ),
            FormCard(
              children: <Widget>[
                Text("Lectures"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: selectedDay,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          child: Text('Monday'),
                          value: 'Monday',
                        ),
                        DropdownMenuItem(
                            child: Text('Tuesday'), value: 'Tuesday'),
                        DropdownMenuItem(
                            child: Text('Wednesday'), value: 'Wednesday'),
                        DropdownMenuItem(
                            child: Text('Thursday'), value: 'Thursday'),
                        DropdownMenuItem(
                            child: Text('Friday'), value: 'Friday'),
                      ],
                      onChanged: (String value) {
                        setState(() {
                          selectedDay = value;
                        });
                      },
                    ),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0)),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () {
                        _showDialog(selectedDay);
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    height: 250.0,
                    child: ListView.builder(
                      itemCount: lts.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Card(
                            child: Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        lts[index][0].toUpperCase() +
                                            " : " +
                                            lts[index][1]['start_time'] +
                                            "-" +
                                            lts[index][1]['end_time'],
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            lts.removeAt(index);
                                          });
                                        },
                                        child:
                                            Icon(Icons.remove_circle_outline),
                                      )
                                    ])));
                      },
                    ))
              ],
            )
          ]),
        ));
  }
}

class FormCard extends StatelessWidget {
  const FormCard({this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 12.0, bottom: 18.0),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}

class MyDialogContent extends StatefulWidget {
  final ValueChanged<List<String>> onAdd;
  MyDialogContent({this.onAdd});
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  @override
  void initState() {
    startTime = TimeOfDay(hour: 9, minute: 0);
    endTime = TimeOfDay(hour: 9, minute: 50);
    super.initState();
  }

  Future<void> _selectTime(BuildContext context, int time) async {
    if (time == 0) {
      final TimeOfDay picked =
          await showTimePicker(context: context, initialTime: startTime);
      if (picked != null && picked != startTime)
        setState(() {
          startTime = picked;
        });
    } else {
      final TimeOfDay picked =
          await showTimePicker(context: context, initialTime: endTime);
      if (picked != null && picked != endTime)
        setState(() {
          endTime = picked;
        });
    }
  }

  var startTime;
  var endTime;

  _getContent() {
    return Container(
        height: 100.0,
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Start Time : "),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _selectTime(context, 0);
                    });
                  },
                  child: Text(startTime.format(context)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("End Time : "),
                RaisedButton(
                  onPressed: () {
                    _selectTime(context, 1);
                  },
                  child: Text(endTime.format(context)),
                )
              ],
            ),
          ],
        ));
  }

  String format(BuildContext context, TimeOfDay t) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      t,
      alwaysUse24HourFormat: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Create Lecture"),
      content: _getContent(),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(100.0)),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: () {
            widget
                .onAdd([format(context, startTime), format(context, endTime)]);
            Navigator.of(context).pop();
          },
          child: Text("ADD"),
        ),
      ],
    );
  }
}
