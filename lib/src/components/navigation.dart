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
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xfff0f0f0),
            child: ListTileTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedColor: Colors.black,
              selectedTileColor: Theme.of(context).primaryColorDark,
              child: ListTile(
                title: Text(name,
                    style: TextStyle(
                      color: _activePage == name ? Colors.white : Colors.black,
                    )),
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

    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: AppNavHeader(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                elevation: 1.0,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: pages.entries
                            .map<Widget>((e) => _navOption(e.key, e.value))
                            .toList() +
                        <Widget>[
                          Spacer(flex: 1),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: _navOption("Settings", "/settings"),
                            ),
                          ),
                        ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppNavHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String displayName = FirebaseAuth.instance.currentUser!.displayName ??
        FirebaseAuth.instance.currentUser!.email!;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
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
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!),
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(displayName),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }
}
