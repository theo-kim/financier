import 'package:flutter/material.dart';

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
  bool elevated;

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late String _activePage;

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
      "Ledger Entry": "/entry",
    };

    return Drawer(
      elevation: (widget.elevated ? 16.0 : 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 245, 245),
          border: Border(
            right: BorderSide(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(1.0),
          children: <Widget>[
                DrawerHeader(
                  child: Text(
                    "Financier",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  decoration: ShapeDecoration(
                    shape: Border(),
                    color: Theme.of(context).primaryColorLight,
                  ),
                )
              ] +
              pages.entries
                  .map<Widget>(
                    (e) => Ink(
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTileTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            selectedColor: Colors.black,
                            selectedTileColor:
                                Theme.of(context).primaryColorDark,
                            child: ListTile(
                              title: Text(e.key),
                              selected: _activePage == e.key,
                              onTap: () {
                                print(widget.elevated);
                                if (widget.elevated) {
                                  widget.onPageChange(e.key);
                                  Navigator.of(context).pop();
                                } else
                                  setState(() {
                                    _activePage = e.key;
                                  });
                                Navigator.of(widget.navigator.currentContext!)
                                    .pushReplacementNamed(e.value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
