import 'package:pincher/src/components/navigation.dart';
import 'package:flutter/material.dart';

class DynamicScaffold extends StatefulWidget {
  DynamicScaffold({
    required key,
    required this.body,
    required this.drawerBuilder,
    this.floatingActionButton,
  }) : super(key: key);

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
      backgroundColor: Color(0xfffafafa),
      drawer: (hideNavDrawer
          ? Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: drawer)
          : null),
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: widget.body,
        ),
      ]),
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
