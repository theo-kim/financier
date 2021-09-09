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
  final bool elevated;

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late String _activePage;

  Widget _navOption(String name, String route) => Ink(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(5.0),
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
        child: Column(children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(1.0),
              children: <Widget>[
                    DrawerHeader(
                      child: Text(
                        "Financier",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      margin: EdgeInsets.zero,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                          side: BorderSide.none,
                        ),
                        color: Theme.of(context).primaryColorLight,
                      ),
                    )
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
