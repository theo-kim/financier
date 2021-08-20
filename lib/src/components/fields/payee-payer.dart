import 'package:financier/src/components/fields/standard-field.dart';
import 'package:flutter/material.dart';

class PayeePayerFormField extends StandardFormField {
  PayeePayerFormField({bool required = true, required onSavedFunction onSaved})
      : super(required, onSaved);

  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (this.required && (value == null || value.length == 0)) {
          return "Payer/Payee field is required";
        }
        return null;
      },
      onSaved: (value) {
        this.onSaved(value);
      },
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
