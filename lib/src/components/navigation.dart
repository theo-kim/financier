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
    return Drawer(
      elevation: (elevated ? 16.0 : 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(1.0),
          children: [
            DrawerHeader(
              child: Text(
                "Financier",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            NavigationEntry(
              title: "Summary",
              destination: SummaryPage(title: "Summary"),
              selected: activePage,
            ),
            NavigationEntry(
              title: "Reports",
              destination: EntryPage(title: "Reports"),
              selected: activePage,
            ),
            NavigationEntry(
              title: "Accounts",
              destination: AccountsPage(title: "Accounts"),
              selected: activePage,
            ),
            NavigationEntry(
              title: "Ledger Entry",
              destination: EntryPage(title: "Ledger Entry"),
              selected: activePage,
            )
          ],
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
  ListTile build(BuildContext context) {
    return ListTile(
      title: Text(title),
      selected: selected == title,
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => destination));
      },
    );
  }
}
