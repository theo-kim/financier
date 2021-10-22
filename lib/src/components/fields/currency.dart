import 'package:flutter/material.dart';

class CurrencyField extends StatelessWidget {
  CurrencyField(
      {required this.onChanged,
      this.required = true,
      required this.errorMessage,
      required this.label,
      this.color = Colors.grey});

  final void Function(double amount) onChanged;
  final bool required;
  final String errorMessage;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String? value) {
        if (this.required && (value == null || value.length == 0)) {
          return errorMessage;
        }
        if ((value != null && value.length > 0) &&
            double.tryParse(value) == null) {
          return "You must express your currency in a decimal number";
        }
        return null;
      },
      style: TextStyle(color: color),
      onChanged: (String? value) {
        double v;
        if (value == null || value.length == 0)
          v = 0.0;
        else {
          v = double.tryParse(value) ?? 0;
        }
        this.onChanged(v);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.label,
        labelStyle: TextStyle(fontSize: 16.0, color: this.color),
        prefixIcon: Icon(
          Icons.attach_money,
          color: this.color,
          size: 16.0,
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
