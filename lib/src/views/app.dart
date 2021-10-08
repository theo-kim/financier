import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:financier/src/views/pages/login.dart';
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
  Future<bool> _setUpApp() async {
    await Firebase.initializeApp();
    preferences = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser == null) {
      // not signed in
      return false;
    }
    AccountActions.manager = AccountActions();
    TransactionActions.manager = TransactionActions();
    await AccountActions.manager.getAllAccounts();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _setUpApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("App initialization error:" + snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return MaterialApp(
            title: 'Finacier',
            theme: ThemeData(
              primarySwatch: Colors.yellow,
            ),
            home: snapshot.data! ? PrimaryStructure("/") : LoginPage(),
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
      },
    );
  }
}
