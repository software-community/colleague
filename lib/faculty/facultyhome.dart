import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

import 'package:colleague/about.dart';
import 'package:colleague/settings.dart';
import './facultyclasses.dart';
import './facultylecture.dart';

class FacultyHome extends StatefulWidget {
  final VoidCallback onSignedOut;
  FacultyHome({this.onSignedOut});
  @override
  State<StatefulWidget> createState() {
    return FacultyHomeState();
  }
}

class FacultyHomeState extends State<FacultyHome>
    with SingleTickerProviderStateMixin {
  Widget frontlayer;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    frontlayer = FacultyLectures();
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildCategory(String category, BuildContext context) {
    final categoryString = category;
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
        onTap: () {
          setState(() {
            if (category == 'Lectures') {
              controller.fling(velocity: 2.0);
              frontlayer = FacultyLectures();
            }
            if (category == 'Courses') {
              controller.fling(velocity: 2.0);
              frontlayer = FacultyClasses();
            }
            if (category == 'Settings') {
              controller.fling(velocity: 2.0);
              frontlayer = Settings();
            }
            if (category == 'About') {
              controller.fling(velocity: 2.0);
              frontlayer = About();
            }
            if (category == 'Switch to Student') {
              Navigator.of(context).pushReplacementNamed('/tastudenthome');
            }
            if (category == 'Logout') {
              widget.onSignedOut();
            }
          });
        },
        child: Column(
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              categoryString,
              style: theme.textTheme.body2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.0),
            Container(
              width: 70.0,
              height: 2.0,
              color: Colors.red,
            ),
          ],
        ));
  }

  Widget backlayer() {
    var navigationList = <Widget>[
      _buildCategory('Lectures', context),
      _buildCategory('Courses', context),
      _buildCategory('Settings', context),
      _buildCategory('About', context),
      _buildCategory('Logout', context),
    ];
    BaseAuth auth = AuthProvider.of(context).auth;
    if (auth.isStudent) {
      navigationList.add(_buildCategory('Switch to Student', context));
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: Colors.blue,
        child: ListView(
          children: navigationList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      controller: controller,
      title: Text('Classes'),
      backLayer: backlayer(),
      frontLayer: frontlayer,
    );
  }
}
