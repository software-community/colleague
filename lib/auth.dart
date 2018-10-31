import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if(user.email == 'kumarashish1550@gmail.com'){
      prefs.setString('token', '2');
      pass = 2;
    }else{
      prefs.setString('token', '1');
      pass = 1;
    }
    print("User is: ${user.displayName}");
    //setState((){
    //    home = HomePage();
    //});
    return pass;
  }
}