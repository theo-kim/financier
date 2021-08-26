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
          backgroundColor: Color.fromARGB(255, 250, 255, 184),
        );
}
