import 'package:flutter/material.dart';

abstract class StandardFormField extends StatelessWidget {
  StandardFormField(this.required, this.onChanged);

  final bool required;
  final Function(String value) onChanged;
}
