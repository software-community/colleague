import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget addStudent() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isOpened ? Colors.black : Colors.transparent,
        ),
        child: Text('Add Student',
            style: isOpened
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.transparent)),
        padding: EdgeInsets.all(10.0),
      ),
      Container(
        margin: EdgeInsets.only(left: 10.0),
        child: FloatingActionButton(
          heroTag: "Add1",
          onPressed: null,
          tooltip: 'Add1',
          child: Icon(Icons.add),
        ),
      )
    ]);
  }

  Widget addTa() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isOpened ? Colors.black : Colors.transparent,
        ),
        child: Text('Add TA',
            style: isOpened
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.transparent)),
        padding: EdgeInsets.all(10.0),
      ),
      Container(
        margin: EdgeInsets.only(left: 10.0),
        child: FloatingActionButton(
          heroTag: "Add2",
          onPressed: null,
          tooltip: 'Add2',
          child: Icon(Icons.add),
        ),
      )
    ]);
  }


  Widget toggle() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      FloatingActionButton(
        heroTag: "tog",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: Icon(isOpened ? Icons.close : Icons.add),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: addStudent(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value ,
            0.0,
          ),
          child: addTa(),
        ),
        toggle(),
      ],
    );
  }
}
