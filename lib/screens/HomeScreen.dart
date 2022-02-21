import 'package:chat_app/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
          child: Center(child: Text("Logout")),
          onPressed: () => logOut(context)),
    );
  }
}

Future logOut(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login())));
  } catch (e) {
    print(e);
  }
}
