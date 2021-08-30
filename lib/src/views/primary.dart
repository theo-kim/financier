import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/dynamic-scaffold.dart';
import 'package:financier/src/components/navigation.dart';
import 'package:financier/src/views/pages/account.dart';
import 'package:financier/src/views/pages/entry.dart';
import 'package:financier/src/views/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PrimaryStructure extends StatefulWidget {
  PrimaryStructure();

  @override
  _PrimaryStructureState createState() => _PrimaryStructureState();
}

class _PrimaryStructureState extends State<PrimaryStructure> {
  String _title = "Summary";
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic> _router(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      if (settings.name == "/") {
        return SummaryPage();
      } else if (settings.name == "/accounts") {
        return AccountsPage();
      } else if (settings.name == "/entry") {
        return EntryPage();
      } else {
        return SummaryPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainNavigator = Navigator(
      initialRoute: "/",
      onGenerateRoute: _router,
      key: _navigatorKey,
    );

    return DynamicScaffold(
      appBar: StandardAppBar(
        title: _title,
      ),
      drawer: NavigationDrawer(
        activePage: _title,
        onPageChange: (String route) {
          setState(() => _title = route);
        },
        navigator: _navigatorKey,
      ),
      body: mainNavigator,
    );
  }
}
