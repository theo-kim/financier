import 'package:flutter/material.dart';

class StandardAppBar extends AppBar {
  StandardAppBar({required String title, PreferredSizeWidget? bottom})
      : super(
          bottom: bottom,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 0,
          shape: Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          ),
        );
}
