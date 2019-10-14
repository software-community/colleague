import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class BaseAuth {
  FirebaseAuth getFirebaseAuth();
  Future<bool> gSignIn(bool isstudent, bool isteacher);
  Future<String> currentUserUID();
  Future<FirebaseUser> currentUser();
  Future<IdTokenResult> currentUserToken();
  Future<void> signOut();
  bool isStudent = false;
  bool isTeacher = false;
  bool isTA = false;
  String id;
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<bool> gSignIn(bool isstudent, bool isteacher) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      // Fetch user from backend

      var data = {'is_student': isstudent, 'is_teacher': isteacher};

      IdTokenResult _idToken = await currentUser.getIdToken();

      var url = DotEnv().env['API_ADDRESS'] + "/accounts/token-login/";
      print(url);
      var client = http.Client();
      var request = http.Request('POST', Uri.parse(url));
      request.headers[HttpHeaders.authorizationHeader] = _idToken.token;
      request.headers['content-type'] = 'application/json';
      request.body = json.encode(data);

      var response = await client.send(request);
      var responsestr = await response.stream.bytesToString();
      var decodeddata = jsonDecode(responsestr);
      id = decodeddata["profile_id"].toString();
      isStudent = decodeddata["is_student"];
      isTeacher = decodeddata["is_teacher"];
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  @override
  Future<String> currentUserUID() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  @override
  Future<IdTokenResult> currentUserToken() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.getIdToken();
  }

  @override
  Future<FirebaseUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  String id;

  @override
  bool isStudent = false;

  @override
  bool isTA = false;

  @override
  bool isTeacher = false;
}
