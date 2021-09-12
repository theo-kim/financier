import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // final currentDateSetting =
    //     DateFormatter.getAvailable(preferences.getString("date_formatter"));
    // print(currentDateSetting);
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Format Preferences",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButtonFormField<DateFormatter>(
            onChanged: (value) {
              if (value != null)
                preferences.setString("date_formatter", value.getName());
            },
            value: DateFormatter.getAvailable(
                preferences.getString("date_formatter")),
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
          Text(
            "Backup and Restore Data",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(children: [
            ElevatedButton(
              onPressed: () {},
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.backup_outlined),
                ),
                Text("Backup Data"),
              ]),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Last backup made on XXXXXX",
                  style: TextStyle(color: Colors.green),
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.green,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ]),
          Row(children: [
            ElevatedButton(
              onPressed: () {},
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.restore_outlined),
                ),
                Text("Restore Data"),
              ]),
            ),
          ])
        ].map<Widget>((w) {
          if (w.runtimeType == Text)
            return Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0), child: w);
          return Padding(padding: EdgeInsets.only(bottom: 10.0), child: w);
        }).toList(),
      ),
    );
  }
}
