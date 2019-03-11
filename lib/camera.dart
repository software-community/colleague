import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'auth.dart';
import 'package:quiver/time.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Camera extends StatefulWidget {
  List<CameraDescription> cameras;
  Camera(this.cameras);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CameraState();
  }
}

class _CameraState extends State<Camera> {
  CameraController controller;
  String imagePath;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
        ],
      ),
    );
  }
    Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  Future<String> takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }
  void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        latestUploadFunction(File(filePath));
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
                child: Image.file(File('newimg.jpg')),
                width: 64.0,
                height: 64.0,
              ),
      ),
    );
  }
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  Future getUploadImg(File _image) async {
    String apiUrl = 'http://192.168.43.203:8000/lectures/api/lecture-image/';
    final length = await _image.length();
    final request = new http.MultipartRequest('GET', Uri.parse(apiUrl))
      ..files.add(new http.MultipartFile('image', _image.openRead(), length));
    http.Response response = await http.Response.fromStream(await request.send());
    print("Result: ${response.body}");
    //return JSON.decode(response.body);
  }
  latestUploadFunction(File imageFile){
    print("SO FAR SO GOOD");
    String base64image = base64Encode(imageFile.readAsBytesSync());
    print("CONVERTED TO BASE 64");
    String filename = imageFile.path.split("/").last;
    print("FILENAME IS");
    print(filename);
    String url = Auth.api_address + "/lectures/api/lecture-image/";
    http.post(url, body: {
      "image":base64image,
      "lecture":"15",
    }).then((response){
      print(response.statusCode);
    }).catchError((error){
      print(error);
    });


  }
  upload(imageFile) async{
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://192.168.43.203:8000/lectures/api/lecture-image/");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    print('resposnesent');
    //print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

  }
}
