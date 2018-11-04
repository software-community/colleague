import 'package:flutter/material.dart';

class FacultyLectures extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FacultyLecturesState();
  }
}

class _FacultyLecturesState extends State<FacultyLectures> {
  List<Widget> _getLecturesCard() {
    final width = MediaQuery.of(context).size.width;
    List<Widget> allLectures = List<Widget>();
    List lectures = ['CSL433', 'CSL123', 'CSL432', 'CSL554'];
    List type = ['P', 'L', 'P', 'L'];
    List numS = ['67', '43', '23', '54'];
    List time = ['10:45 AM', '10:45 AM', '10:45 AM', '10:45 AM'];
    for (int i = 0; i < lectures.length; i++) {
      allLectures.add(Card(
        elevation: 10.0,
        child: Container(
          margin: EdgeInsets.all(5.0),
          height: 60.0,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    lectures[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    type[i],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(time[i]),
                    Align(
                      alignment: Alignment(-3.0, -4.0),
                      child: Icon(
                        Icons.face,
                      ),
                    ),
                    Text(numS[i]),
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return allLectures;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
      child: ListView(
        children: _getLecturesCard(),
      ),
    );
  }
}
