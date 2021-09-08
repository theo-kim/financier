import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/dynamic-scaffold.dart';
import 'package:financier/src/components/navigation.dart';
import 'package:financier/src/views/pages/account.dart';
import 'package:financier/src/views/pages/transactions.dart';
import 'package:financier/src/views/pages/summary.dart';
import 'package:flutter/material.dart';

class PrimaryStructure extends StatefulWidget {
  PrimaryStructure();

  @override
  _PrimaryStructureState createState() => _PrimaryStructureState();
}

class _PrimaryStructureState extends State<PrimaryStructure> {
  String _title = "Summary";
  FloatingActionButton? _floatingActionButton;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void FABSet(FloatingActionButton fab) {
    print("fab");
    setState(() {
      _floatingActionButton = fab;
    });
  }

  Route<dynamic> _router(RouteSettings settings) {
    // final isMobile = MediaQuery.of(context).size.shortestSide < 700;

    final _builder = (BuildContext context) {
      if (settings.name == "/") {
        return SummaryPage();
      } else if (settings.name == "/accounts") {
        return AccountsPage();
      } else if (settings.name == "/transactions") {
        return TransactionPage();
      } else {
        return SummaryPage();
      }
    };

    return PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => _builder(context),
      transitionDuration: Duration.zero,
    );
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
      drawerBuilder: (bool isHidden) => NavigationDrawer(
        elevated: isHidden,
        activePage: _title,
        onPageChange: (String route) {
          setState(() => _title = route);
        },
        navigator: _navigatorKey,
      ),
      body: mainNavigator,
      floatingActionButton: _floatingActionButton,
    );
  }
}
