import 'package:financier/src/views/pages/account.dart';
import 'package:financier/src/views/pages/entry.dart';
import 'package:financier/src/views/pages/summary.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key, required this.activePage, this.elevated = true})
      : super(key: key);

  final String activePage;
  bool elevated;

  @override
  Drawer build(BuildContext context) {
    final pages = <String, Widget>{
      "Summary": SummaryPage(title: "Summary"),
      "Accounts": AccountsPage(title: "Accounts"),
      "Ledger Entry": EntryPage(title: "Ledger Entry"),
    };

    return Drawer(
      elevation: (elevated ? 16.0 : 0.0),
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
                  .map<Widget>((e) => NavigationEntry(
                        title: e.key,
                        destination: e.value,
                        selected: activePage,
                      ))
                  .toList(),
        ),
      ),
    );
  }
}

class NavigationEntry extends StatelessWidget {
  NavigationEntry(
      {Key? key,
      required this.title,
      required this.destination,
      required this.selected})
      : super(key: key);

  final String title;
  final Widget destination;
  final String selected;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Colors.black,
      tileColor: Colors.black,
      selectedTileColor: Theme.of(context).primaryColorDark,
      child: ListTile(
        title: Text(title),
        selected: selected == title,
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => destination));
        },
      ),
    );
  }
}
