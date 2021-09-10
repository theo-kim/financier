import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:flutter/material.dart';

typedef void onSavedFunctionDateTime(DateTime value);

class TransactionDateField extends StatelessWidget {
  TransactionDateField(this.dateController,
      {required this.onSaved, this.required = true});

  final TextEditingController dateController;
  final onSavedFunctionDateTime onSaved;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: dateController,
      validator: (value) {
        if (value == null || value.length == 0) {
          return "Transaction date is required";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Transaction Date",
        labelStyle: TextStyle(fontSize: 16.0),
        prefixIcon: Icon(
          Icons.calendar_today,
          color: Colors.black,
          size: 16.0,
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
      onSaved: (value) {
        if (value != null) {
          this.onSaved(DateFormatter.getAvailable(
                  preferences.getString("date_formatter"))
              .unformatDate(value)
              .toUtc());
        }
      },
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          dateController.text = DateFormatter.getAvailable(
                  preferences.getString("date_formatter"))
              .formatDate(date);
        }
      },
    );
  }
}
