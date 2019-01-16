import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Auth{
  static final api_address = "http://192.168.43.203:8000";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = new GoogleSignIn();

  Future<bool> gLogout() async{
    _googleSignin.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");
    return true;
  }

  Future<int> gSignin() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignin.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('User id is : ${user.email}');
    String token = await user.getIdToken();
    prefs.setString("token", token);
    print('this is the correct token');
    print(token);
    //String token = await user.getIdToken();
    //print("token is : ${token}");
    print("User is: ${user.displayName}");
    // List<int> datalist = await verifyToken(token);
    var url = api_address+"/accounts/token-login/";
    var client = http.Client();
    print(url);
    var request = http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.AUTHORIZATION] = token;
    print("VERIFYING THE TOKEN");
    var response = await client.send(request);
    var responsestr = await response.stream.bytesToString();
    print("printing repsonse stirng");
    print(responsestr);
    var decodeddata = jsonDecode(responsestr);
    List<int> datalist = List();
    datalist.add(decodeddata["profile_id"]);
    if(decodeddata["is_student"] == true && decodeddata["is_teacher"] == true){
      datalist.add(3);
    }
    else if(decodeddata["is_student"] == true){
      print("yes it is true you jackaass");
      datalist.add(1);
    }else if(decodeddata["is_teacher"] == true){
      datalist.add(2);
    }
    //setState((){
    //    home = HomePage();
    //});
    print("printing what is retuned");
    print(datalist);
    return datalist[1];
  }
}