import 'package:financier/src/components/navigation.dart';
import 'package:flutter/material.dart';

class DynamicScaffold extends StatefulWidget {
  DynamicScaffold(
      {required this.appBar,
      required this.body,
      this.drawer,
      this.floatingActionButton});

  final PreferredSizeWidget appBar;
  final NavigationDrawer? drawer;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  _DynamicScaffoldState createState() => _DynamicScaffoldState();
}

class _DynamicScaffoldState extends State<DynamicScaffold> {
  @override
  Widget build(BuildContext context) {
    final smallestDimension = MediaQuery.of(context).size.shortestSide;
    bool hideNavDrawer = widget.drawer != null && smallestDimension < 700;

    Widget scaffold = Scaffold(
      appBar: widget.appBar,
      drawer: (hideNavDrawer ? widget.drawer : null),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );

    if (widget.drawer != null && !hideNavDrawer) {
      widget.drawer!.elevated = false;
      return Row(children: <Widget>[
        widget.drawer!,
        Expanded(child: scaffold),
      ]);
    } else {
      widget.drawer!.elevated = true;
    }
    return scaffold;
  }
}
