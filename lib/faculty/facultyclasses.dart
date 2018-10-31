import 'package:flutter/material.dart';

class FacultyClasses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FacultyClassesState();
  }
}

class _FacultyClassesState extends State<FacultyClasses> {

  List<Widget> _getClassesCard(){
    final width = MediaQuery.of(context).size.width;
    List<Widget> allClasses = List<Widget>();
    List classes = ['class1', 'class2', 'class3', 'class4'];
    for(int i = 0; i < classes.length; i++){
      allClasses.add(Card(
        margin: EdgeInsets.symmetric(
          horizontal: width * .015,
          vertical: width * .01,
        ),
        elevation: 10.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(classes[i]),
          ],
        ),
      ));
    }
    return allClasses;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0))),
      child: ListView(
        children: _getClassesCard(),
      ),
    );
  }
}
