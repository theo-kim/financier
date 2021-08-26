import 'package:flutter/material.dart';

class CurrencyField extends StatelessWidget {
  CurrencyField(
      {required this.onSaved,
      this.required = true,
      required this.errorMessage,
      required this.label});

  final void Function(double amount) onSaved;
  final bool required;
  final String errorMessage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (this.required && value == null) {
          return errorMessage;
        }
        if (double.tryParse(value as String) == null) {
          return errorMessage;
        }
        return null;
      },
      onSaved: (String? value) {
        double v = double.parse(value!);
        this.onSaved(v);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.label,
        labelStyle: TextStyle(fontSize: 16.0),
        prefixIcon: Icon(
          Icons.attach_money,
          color: Colors.black,
          size: 16.0,
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
