import 'package:flutter/material.dart';
import '../objects/allobjects.dart';
import 'package:photo_view/photo_view.dart';

class ShowImages extends StatefulWidget {
  Lecture missedLecture;
  ShowImages(this.missedLecture);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowImagesState();
  }
}

class ShowImagesState extends State<ShowImages> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close),
                      )
                    ])),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) =>
                            FullScreenImage("graphics/1.png")));
              },
              child: Hero(
                tag: "hero1",
                child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Image.asset(
                        "graphics/1.png",
                      ),
                    )),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) =>
                            FullScreenImage("graphics/2.png")));
              },
              child: Hero(
                tag: "hero2",
                child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Image.asset(
                        "graphics/2.png",
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  String imagepath;
  FullScreenImage(this.imagepath);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('loader to be added'),
          content: Text(
              ''),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(children: [
        SizedBox(
          height: width * 0.87,
          child: PhotoView(
            imageProvider: AssetImage("graphics/2.png"),
          ),
        ),
        RaisedButton(
          color: Colors.blue[700],
          child: Text('Send as Proof'),
          onPressed: () {
            _showInfoDialog(context);
          },
        ),
      ]),
    );
  }
}
