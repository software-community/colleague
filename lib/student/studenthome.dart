import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

import 'classes.dart';
import 'package:colleague/about.dart';
import 'package:colleague/settings.dart';
import 'profile.dart';

class StudentHome extends StatefulWidget {
  final VoidCallback onSignedOut;
  StudentHome({this.onSignedOut});
  @override
  State<StatefulWidget> createState() {
    return StudentHomeState();
  }
}

class StudentHomeState extends State<StudentHome>
    with SingleTickerProviderStateMixin {
  Widget frontlayer = Classes();
  AnimationController controller;
  BaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = AuthProvider.of(context).auth;
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
            if (category == 'Classes') {
              controller.fling(velocity: 2.0);
              frontlayer = Classes();
            }
            if (category == 'Settings') {
              controller.fling(velocity: 2.0);
              frontlayer = Settings();
            }
            if (category == 'About') {
              controller.fling(velocity: 2.0);
              frontlayer = About();
            }
            if (category == 'Profile') {
              controller.fling(velocity: 2.0);
              frontlayer = Profile();
            }
            if (category == 'Switch to TA') {
              Navigator.of(context).pushReplacementNamed('/tahome');
            }
            if (category == 'Logout') {
              auth.signOut().then((result) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
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
      _buildCategory('Classes', context),
      _buildCategory('Settings', context),
      _buildCategory('About', context),
      _buildCategory('Logout', context),
      _buildCategory('Profile', context)
    ];
    // if (widget.clearance == 1) {
    //   navigationList.add(_buildCategory('Switch to TA', context));
    // }
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
    // TODO: implement build
    return BackdropScaffold(
      controller: controller,
      title: Text('Classes'),
      backLayer: backlayer(),
      frontLayer: frontlayer,
    );
  }
}
