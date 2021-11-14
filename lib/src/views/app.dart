import 'package:pincher/src/operations/master.dart';
import 'package:pincher/src/operations/preferences.dart';
import 'package:pincher/src/views/pages/login.dart';
import 'package:pincher/src/views/primary.dart';
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
    try {
      await app.initialize();
    } on UnauthenticatedError {
      return false;
    } on NonexistantRecordError {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _setUpApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          print(snapshot.stackTrace);
          return MaterialApp(
              title: 'Pincher',
              theme: ThemeData(
                primarySwatch: Colors.red,
              ),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        "App initialization error:" + snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )))));
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return MaterialApp(
            title: 'Pincher',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            debugShowCheckedModeBanner: false,
            home: snapshot.data! ? PrimaryStructure("/") : LoginPage(),
          );
        }
        return MaterialApp(
          title: 'Pincher',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
