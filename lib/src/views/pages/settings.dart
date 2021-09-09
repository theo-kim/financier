import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          DropdownButtonFormField<DateFormatter>(
            onChanged: (value) {
              if (value != null)
                preferences.setString("date_formatter", value.getName());
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Date Format Preference",
              labelStyle: TextStyle(fontSize: 16.0),
              contentPadding: EdgeInsets.all(10.0),
            ),
            items: DateFormatter.available.entries
                .map<DropdownMenuItem<DateFormatter>>(
                  (e) => DropdownMenuItem<DateFormatter>(
                    child: Text(e.value.getName()),
                    value: e.value,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
