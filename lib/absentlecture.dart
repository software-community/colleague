import 'package:flutter/material.dart';

class AbsentLecture extends StatelessWidget {
  final int lectureID;
  final int studentID;
  const AbsentLecture({
    @required this.lectureID,
    @required this.studentID,
  });

  void _showInfoDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Missed Lecture'),
          content: Text('You missed this lecture, click on the lecture box to view images of this lecture or cross icon to remove it'),
        );
      },
    );
  }

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
                GestureDetector(
                  onTap: (){
                    _showInfoDialog(context);
                  },
                  child: Icon(
                    Icons.error,
                    color: Colors.grey[300],
                  ),
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
