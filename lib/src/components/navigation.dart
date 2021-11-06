// import 'dart:html';

import 'package:financier/src/views/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/* used for network images */

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer(
      {Key? key,
      required this.activePage,
      required this.navigator,
      required this.onPageChange,
      this.elevated = true})
      : super(key: key);

  final String activePage;
  final Function(String route) onPageChange;
  final GlobalKey<NavigatorState> navigator;
  final bool elevated;

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late String _activePage;

  Widget _navOption(String name, String route) => Ink(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xfff0f0f0),
            child: ListTileTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedColor: Colors.black,
              selectedTileColor: Theme.of(context).primaryColorDark,
              child: ListTile(
                title: Text(name),
                selected: _activePage == name,
                onTap: () {
                  widget.onPageChange(name);
                  if (widget.elevated) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _activePage = name;
                    });
                  }
                  Navigator.of(widget.navigator.currentContext!)
                      .pushReplacementNamed(route);
                },
              ),
            ),
          ),
        ),
      );

  @override
  void initState() {
    _activePage = widget.activePage;
    super.initState();
  }

  @override
  Drawer build(BuildContext context) {
    final pages = <String, String>{
      "Summary": "/",
      "Accounts": "/accounts",
      "Transactions": "/transactions",
    };

    String displayName = FirebaseAuth.instance.currentUser!.displayName ??
        FirebaseAuth.instance.currentUser!.email!;

    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.transparent,
        child: Column(children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: Material(
                        elevation: 6.0,
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                        color: Theme.of(context).primaryColorLight,
                        child: DrawerHeader(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 10.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(FirebaseAuth
                                              .instance.currentUser!.photoURL!),
                                          width: 40.0,
                                          height: 40.0,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text(displayName),
                                          TextButton(
                                            onPressed: () {
                                              FirebaseAuth.instance
                                                  .signOut()
                                                  .then((value) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text(
                                              "Logout",
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                Text(
                                  "Pincher",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ] +
                  pages.entries
                      .map<Widget>((e) => _navOption(e.key, e.value))
                      .toList(),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: _navOption("Settings", "/settings"),
            ),
          )
        ]),
      ),
    );
  }
}
