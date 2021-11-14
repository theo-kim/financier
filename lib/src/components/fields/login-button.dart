import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  LoginButton({
    required this.label,
    required this.icon,
    required this.background,
    this.textStyle,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final Color background;
  final TextStyle? textStyle;
  final Function() onPressed;

  ButtonStyle _buttonShape(Color c) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(background),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        side: BorderSide.none,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: _buttonShape(Colors.grey),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: icon,
            ),
            Text(
              label,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
