import 'dart:math';

import 'package:financier/src/components/login-button.dart';
import 'package:financier/src/views/pages/registration.dart';
import 'package:financier/src/views/primary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _textFieldValueHolder = TextEditingController();

  Future<User?> _signIn(UserCredential credential) async {
    return credential.user;
  }

  Future<User?> _signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount;
    var account = await _googleSignIn.signIn();
    if (account != null) {
      googleSignInAccount = account;
    } else {
      throw "Login cancelled";
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return _signIn(await _auth.signInWithCredential(credential));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10 + max((MediaQuery.of(context).size.width - 400) / 2, 0),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Welcome to Pincher!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    "Keep track of and analyze your personal books, and pinch some pennies!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ] +
              <Widget>[
                Material(
                  child: TextField(
                    controller: _textFieldValueHolder,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email Address",
                    ),
                  ),
                ),
                LoginButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            RegistrationPage(_textFieldValueHolder.value.text),
                      ),
                    );
                  },
                  icon: Icon(Icons.mail, color: Colors.black),
                  label: "Continue with Email",
                  background: Color(0xffe8e8e8),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
                Text(
                  "Or",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                  ),
                ),
                LoginButton(
                  onPressed: () {
                    _signInWithGoogle().then((u) {
                      if (u == null) throw "Null user";
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrimaryStructure("/"),
                        ),
                      );
                    }).catchError((err) {
                      print("Login cancelled");
                    });
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  label: "Sign in with Google",
                  background: Colors.blue,
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ]
                  .map<Widget>((e) => Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: e,
                      ))
                  .toList()),
    );
  }
}
