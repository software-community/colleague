import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  File _imageUpload;
  List<Widget> listImages = List();
  
  Future openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageUpload = image;
    });
  }

  Future openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageUpload = image;
    });
  }

  Future<void> _optionsDialogBox() {
  return showDialog(context: context,
    builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: openCamera,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: openGallery,
                ),
              ],
            ),
          ),
        );
      });
}

  Widget ImageTemplate(String url, int id){
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(url),
          RaisedButton(
            onPressed: (){},
            child: Text("Delete this image"),
          ),
        ],
      ),
    );
  }
  Widget _profileImages(){
    listImages.clear();
    listImages.add(ImageTemplate("https://media.gettyimages.com/photos/rear-view-of-person-sitting-on-boat-in-lake-picture-id678834121", 1));
    listImages.add(ImageTemplate("https://media.gettyimages.com/photos/rear-view-of-person-sitting-on-boat-in-lake-picture-id678834121", 1));
    return ListView(children: listImages,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_box),
          elevation: 20.0,
          onPressed: _optionsDialogBox,
          tooltip: "Upload Image",
          shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
        body: _profileImages(),
    );
  }
}
