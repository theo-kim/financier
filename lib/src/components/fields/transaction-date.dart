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
          List<String> split = value.split("-");
          this.onSaved(DateTime(
                  int.parse(split[2]), int.parse(split[0]), int.parse(split[1]))
              .toUtc());
        }
      },
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          dateController.text = "${date.month}-${date.day}-${date.year}";
        }
      },
    );
  }
}
