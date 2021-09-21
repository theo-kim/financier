import 'package:financier/src/components/fields/standard-field.dart';
import 'package:flutter/material.dart';

class TransactionDetailsField extends StandardFormField {
  TransactionDetailsField(
      {bool required = true, required OnSavedFunction onSaved})
      : super(required, onSaved);

  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (this.required && (value != null && value.length > 100)) {
          return "Transaction details cannot exceed 100 characters";
        }
        return null;
      },
      onSaved: (value) {
        this.onSaved(value);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Transaction Details",
        labelStyle: TextStyle(fontSize: 16.0),
        prefixIcon: Icon(
          Icons.notes,
          color: Colors.black,
          size: 16.0,
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
