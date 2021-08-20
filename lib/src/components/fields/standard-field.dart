import 'package:flutter/material.dart';

typedef void onSavedFunction(String? value);

abstract class StandardFormField extends StatelessWidget {
  StandardFormField(this.required, this.onSaved);

  final bool required;
  final onSavedFunction onSaved;
}
