import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Auth{
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
    int pass = 0;
    if(user.email == 'kumarashish1550@gmail.com' || user.email == 'dilipsharma640@gmail.com'){
      prefs.setString('token', '2');
      pass = 2;
    }else{
      prefs.setString('token', '1');
      pass = 1;
    }
    String token = await user.getIdToken();
    print('this is the correct token');
    print(token);
    //String token = await user.getIdToken();
    //print("token is : ${token}");
    print("User is: ${user.displayName}");
    verifyToken(token);
    //setState((){
    //    home = HomePage();
    //});
    return pass;
  }
  void verifyToken(String token){
    // var url = "https://calm-brushlands-46408.herokuapp.com/test/";
    // var url = "http://172.21.6.23:8000/accounts/token-auth/";
    var url = "http://172.21.6.23:8000/lectures/api/sal/3/";
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    // var body = {'id_token':token};
    // request.bodyFields = body;
    request.headers[HttpHeaders.AUTHORIZATION] = token;
    var future = client.send(request).then((response){
      response.stream.bytesToString().then((value){
        print(value.toString());
      }).catchError((error){
        print(error.toString());
      });
    });
  }
}