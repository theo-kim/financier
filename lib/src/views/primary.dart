import 'package:date_format/date_format.dart';
import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/dynamic-scaffold.dart';
import 'package:financier/src/components/navigation.dart';
import 'package:financier/src/views/pages/account.dart';
import 'package:financier/src/views/pages/login.dart';
import 'package:financier/src/views/pages/settings.dart';
import 'package:financier/src/views/pages/transactions.dart';
import 'package:financier/src/views/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Map<String, String> routeToTitle = {
  "/": "Summary",
  "/transactions": "Transactions",
  "/settings": "Settings",
  "/accounts": "Accounts"
};

class BackNavigateIntent extends Intent {}

class PrimaryStructure extends StatefulWidget {
  PrimaryStructure(this.initialRoute) {
    if (!routeToTitle.containsKey(initialRoute))
      throw "Invalid initial route for application";
  }

  final String initialRoute;

  @override
  _PrimaryStructureState createState() => _PrimaryStructureState();
}

class _PrimaryStructureState extends State<PrimaryStructure> {
  late String _title;
  FloatingActionButton? _floatingActionButton;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _changePageTitle(String route) {
    setState(() => _title = route);
  }

  final _backNavigateShortcut = LogicalKeySet(
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.backspace,
  );

  final _transactionNavigateShortcut = LogicalKeySet(
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.keyT,
  );

  final _accountNavigateShortcut = LogicalKeySet(
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.keyA,
  );

  void _backNavigate() {
    if (Navigator.of(_navigatorKey.currentContext!).canPop() == true) {
      Navigator.of(_navigatorKey.currentContext!).pop();
    }
  }

  void _navigateTo(String route, String name) {
    if (_navigatorKey.currentContext != null) {
      _changePageTitle(name);
      Navigator.of(_navigatorKey.currentContext!).pushReplacementNamed(route);
    }
  }

  Route<dynamic> _router(RouteSettings settings) {
    final _builder = (BuildContext context) {
      if (settings.name == "/") {
        return SummaryPage();
      } else if (settings.name == "/accounts") {
        return AccountsPage();
      } else if (settings.name == "/transactions") {
        return TransactionPage();
      } else if (settings.name == "/settings") {
        return SettingsPage();
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
  void initState() {
    _title = routeToTitle[widget.initialRoute]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainNavigator = Navigator(
      initialRoute: widget.initialRoute,
      onGenerateRoute: _router,
      key: _navigatorKey,
    );

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        _backNavigateShortcut: BackNavigateIntent(),
        _transactionNavigateShortcut: TransactionPageIntent(),
        _accountNavigateShortcut: AccountPageIntent(),
      },
      actions: {
        TransactionPageIntent: CallbackAction(
          onInvoke: (e) => _navigateTo("/transactions", "Transactions"),
        ),
        AccountPageIntent: CallbackAction(
          onInvoke: (e) => _navigateTo("/accounts", "Accounts"),
        ),
        BackNavigateIntent: CallbackAction(
          onInvoke: (e) => _backNavigate(),
        ),
      },
      child: DynamicScaffold(
        key: UniqueKey(),
        appBar: StandardAppBar(
          title: _title,
        ),
        drawerBuilder: (bool isHidden) => NavigationDrawer(
          elevated: isHidden,
          activePage: _title,
          onPageChange: _changePageTitle,
          navigator: _navigatorKey,
        ),
        body: mainNavigator,
        floatingActionButton: _floatingActionButton,
      ),
    );
  }
}
