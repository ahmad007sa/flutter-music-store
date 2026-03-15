import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicstore/pages/viewpage.dart';
import 'package:musicstore/pages/welcome_page.dart';

final _firebase = FirebaseAuth.instance; // firebase auth intializing...

enum AuthStaus {
  notLoggedIn,
  loggedIn
} // status if any user loggedin on startup of application

class CheckLog extends StatefulWidget {
  const CheckLog({super.key});

  @override
  State<CheckLog> createState() => _CheckLogState();
}

class _CheckLogState extends State<CheckLog> {
  AuthStaus status = AuthStaus.notLoggedIn;

//call when widget intialize... to check if any user loggedin and update value of status
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final user = _firebase.currentUser;
    setState(() {
      status = user == null ? AuthStaus.notLoggedIn : AuthStaus.loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if user logged in go to store directly...if not go to welcome page...
    return status == AuthStaus.loggedIn
        ? const ViewPage()
        : const WelcomePage();
  }
}
