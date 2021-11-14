import 'package:pincher/src/components/fields/standard-field.dart';
import 'package:flutter/material.dart';

class PayeePayerFormField extends StandardFormField {
  PayeePayerFormField(
      {bool required = true, required Function(String?) onChanged})
      : super(required, onChanged);

  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (this.required && value == null) {
          return "Payer/Payee field is required";
        }
        return null;
      },
      onChanged: this.onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Payer/Payee",
        labelStyle: TextStyle(fontSize: 16.0),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black,
          size: 16.0,
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
