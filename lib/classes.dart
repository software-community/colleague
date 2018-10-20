import 'package:flutter/material.dart';

class Classes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ClassesState();
  }
}

class _ClassesState extends State<Classes> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var classcard = Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        elevation: 2.0,
        child: Container(
          height: 200.0,
          alignment: Alignment(0.0, -0.4),
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              strokeWidth: 15.0,
              value: 0.7,
            ),
          ),
        ),
      ),
    );
    return classcard;
  }
}
