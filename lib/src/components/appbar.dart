import 'package:flutter/material.dart';

class StandardAppBar extends StatelessWidget {
  StandardAppBar({required this.title, this.bottom});

  final String title;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: AppBar(
        bottom: this.bottom,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
