import 'package:flutter/material.dart';

class MarkAttendence extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarkAttendenceState();
  }
}

class _MarkAttendenceState extends State<MarkAttendence> {
  var students = [
    ['2017\n csb\n1073', 'A'],
    ['73', 'A'],
    ['74', 'A'],
    ['75', 'A'],
    ['76', 'A'],
    ['77', 'A'],
    ['78', 'A'],
    ['79', 'A'],
    ['80', 'P'],
    ['81', 'P'],
    ['82', 'A'],
    ['83', 'A'],
    ['84', 'A'],
    ['85', 'A']
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.photo),
          backgroundColor: new Color(0xFFE57373),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => Page2()));
          }),
      appBar: AppBar(
        title: Text('CS201'),
      ),
      body: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? 4
                    : 5),
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                setState(() {
                  if (students[index][1] == 'A')
                    students[index][1] = 'P';
                  else
                    students[index][1] = 'A';
                });
              },
              child: _StudentCard(students[index]));
        },
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final List id;
  _StudentCard(this.id);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: id[1] == 'A' ? Colors.red : Colors.green,
        child: Center(
            child: Text(
          id[0],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )));
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: OutlineButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.close),
            )),
            Hero(
              tag: "hero1",
              child: Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Image.asset(
                      "graphics/1.png",
                    ),
                  )),
            ),
            Hero(
              tag: "hero2",
              child: Container(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Image.asset(
                      "graphics/2.png",
                    ),
                  )),
            )
            
          ],
        ),
      ),
    );
  }
}
