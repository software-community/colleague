import 'package:flutter/material.dart';

class AbsentLecture extends StatelessWidget {
  final int lectureID;
  final int studentID;
  const AbsentLecture({
    @required this.lectureID,
    @required this.studentID,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.grey[600],
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      child: Container(
        height: 30.0,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          highlightColor: Colors.red[900],
          splashColor: Colors.red[900],
          onTap: () {
            print('i was tapped');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.error,
                  color: Colors.grey[300],
                ),
                Center(
                  child: Text(
                    'Lecture 1',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
