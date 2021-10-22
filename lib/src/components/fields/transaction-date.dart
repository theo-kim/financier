import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:flutter/material.dart';

class TransactionDateField extends StatelessWidget {
  TransactionDateField(this.dateController,
      {required this.onChanged, this.required = true});

  final TextEditingController dateController;
  final Function(DateTime? d) onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    dateController.addListener(() {
      if (dateController.value.text.length == 0)
        this.onChanged(null); // TODO: test
      else {
        this.onChanged(
            DateFormatter.getAvailable(preferences.getString("date_formatter"))
                .unformatDate(dateController.value.text)
                .toUtc());
      }
    });

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
      initialValue: null,
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
