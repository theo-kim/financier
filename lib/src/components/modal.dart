import 'dart:math';

import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  Modal({
    required this.title,
    this.bottom,
    required this.body,
    required this.acceptButtonText,
    required this.onSubmit,
  });

  final String title;
  final Widget? bottom;
  final Widget body;
  final String acceptButtonText;
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: min(MediaQuery.of(context).size.width, 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Theme.of(context).accentColor,
              elevation: 6.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 30, left: 20, right: 20, bottom: 10),
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (bottom != null) bottom!,
                ],
              ),
            ),
            body,
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onSubmit,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        acceptButtonText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
