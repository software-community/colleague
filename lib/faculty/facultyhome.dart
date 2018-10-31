import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

import '../about.dart';
import '../settings.dart';
import '../auth.dart';
import './facultyclasses.dart';
class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
class FacultyHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FacultyHomeState();
  }
}

class FacultyHomeState extends State<FacultyHome> with SingleTickerProviderStateMixin {
  Widget frontlayer = FacultyClasses();
  AnimationController controller;
  Auth auth = Auth();
  @override
  void initState(){
    super.initState();
    print('init state');
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
    final categoryString =
        category;
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          if(category=='Classes'){
            controller.fling(velocity: 2.0);
            frontlayer=FacultyClasses();
          }
          if(category=='Settings'){
            controller.fling(velocity: 2.0);
            frontlayer=Settings();
          }
          if(category=='About'){
            controller.fling(velocity: 2.0);
            frontlayer=About();
          }
          if(category=='Logout'){
            auth.gLogout().then((result) {
              if (result) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
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
        )
    );
  }

  Widget backlayer(){
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            _buildCategory('Classes', context),
            _buildCategory('Settings', context),
            _buildCategory('About', context),
            _buildCategory('Logout', context),
          ],
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
