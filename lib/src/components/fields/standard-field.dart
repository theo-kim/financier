import 'package:flutter/material.dart';

typedef void OnSavedFunction(String? value);

abstract class StandardFormField extends StatelessWidget {
  StandardFormField(this.required, this.onSaved);

  final bool required;
  final OnSavedFunction onSaved;
}
