import 'package:financier/src/components/login-button.dart';
import 'package:financier/src/views/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _login() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginButton(
              icon: Icon(Icons.mail, color: Colors.black),
              label: "Sign in with Email",
              background: Colors.white,
              textStyle: TextStyle(fontSize: 16.0),
            ),
            LoginButton(
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
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RegistrationPage(),
              ),
            );
          },
          child: Text("Create an account"),
        ),
      ],
    );
  }
}
