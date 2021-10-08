import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage(this.email);

  final String email;

  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User?> _signInWithEmail() async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: "barry.allen@example.com",
  //       password: "SuperSecretPassword!",
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.email),
    ]);
  }
}
