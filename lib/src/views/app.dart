import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:financier/src/views/primary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  Future<void> _setUpApp() async {
    await Firebase.initializeApp();
    // TODO Remove Anonymous sign in
    await FirebaseAuth.instance.signInAnonymously();
    AccountActions.manager = AccountActions();
    TransactionActions.manager = TransactionActions();
    preferences = await SharedPreferences.getInstance();
    await AccountActions.manager.getAllAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _setUpApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }
          // Once complete, show your application
          else if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Finacier',
              theme: ThemeData(
                primarySwatch: Colors.yellow,
              ),
              home: PrimaryStructure(),
            );
          }
          return MaterialApp(
            title: 'Finacier',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
