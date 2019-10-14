import 'package:colleague/faculty/facultyhome.dart';
import 'package:colleague/student/studenthome.dart';
import 'package:flutter/material.dart';
import 'package:colleague/auth/auth.dart';
import 'package:colleague/auth/login_page.dart';
import 'package:colleague/auth/auth_provider.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUserUID().then((String userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        {
          final BaseAuth auth = AuthProvider.of(context).auth;
          if (auth.id == null) {
            _signedOut();
            return LoginPage(
              onSignedIn: _signedIn,
            );
          } else if (auth.isStudent)
            return StudentHome(
              onSignedOut: _signedOut,
            );
          else if (auth.isTeacher)
            return FacultyHome(
              onSignedOut: _signedOut,
            );
        }
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
