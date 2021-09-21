import 'package:financier/src/views/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _login() {}

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonShape(Color c) => ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(90.0),
            ),
            side: BorderSide.none,
          )),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(10.0)),
        );

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
        ElevatedButton(
          onPressed: () {},
          style: buttonShape(Colors.grey),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.mail, color: Colors.black),
              Text("Login with Email"),
            ],
          ),
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
