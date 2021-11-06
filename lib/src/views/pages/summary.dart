import 'package:financier/src/components/appbar.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  SummaryPage() : super();

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      StandardAppBar(title: "Summary"),
      Stack(children: [
        Center(
          child: Text("hello world!"),
        )
      ])
    ]);
  }
}
