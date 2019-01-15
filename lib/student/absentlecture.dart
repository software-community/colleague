import 'package:flutter/material.dart';
import '../objects/allobjects.dart';
class AbsentLecture extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final heightTween = Tween<double>(begin: 0.0, end: 30.0);
  final widthTween;
  final Lecture missed;

  const AbsentLecture({
    Key key,
    Animation<double> animation,
    @required this.missed,
    @required this.widthTween,
  }):  super(key:key, listenable: animation);

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
  Widget _getLectureContainer(BuildContext context, Animation<double> animation){
    double width = MediaQuery.of(context).size.width;
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
            // what to do when an absent lecture container is tapped
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
                    missed.code,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[300],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // TODO: implement build
    Animation<double> animation = listenable;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          height: 30.0,
          width: width*.52,
          child: _getLectureContainer(context, animation),
        ),
      ),
    );
  }
}
