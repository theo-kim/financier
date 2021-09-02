import 'package:financier/src/components/navigation.dart';
import 'package:flutter/material.dart';

class DynamicScaffold extends StatefulWidget {
  DynamicScaffold(
      {required this.appBar,
      required this.body,
      required this.drawerBuilder,
      this.floatingActionButton});

  final PreferredSizeWidget appBar;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final NavigationDrawer Function(bool hidden) drawerBuilder;

  _DynamicScaffoldState createState() => _DynamicScaffoldState();
}

class _DynamicScaffoldState extends State<DynamicScaffold> {
  bool _getIsWide() {
    final smallestDimension = MediaQuery.of(context).size.shortestSide;
    return smallestDimension < 700;
  }

  @override
  Widget build(BuildContext context) {
    bool hideNavDrawer = _getIsWide();
    NavigationDrawer drawer = widget.drawerBuilder(hideNavDrawer);

    Widget scaffold = Scaffold(
      appBar: widget.appBar,
      drawer: (hideNavDrawer ? drawer : null),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );

    if (!hideNavDrawer) {
      return Row(children: <Widget>[
        drawer,
        Expanded(child: scaffold),
      ]);
    }
    return scaffold;
  }
}
