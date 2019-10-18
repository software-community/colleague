import 'package:flutter/material.dart';

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

  _selectTime(BuildContext context, int time) async {
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
        width: 100.0,
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
