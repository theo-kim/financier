import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/operations/backup.dart';
import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

enum _RestoreOption { Account, Transaction }

enum _RestorationStatus { Success, Fail, Cancelled }

class _RestorationResult {
  _RestorationResult(this.status, this.data);

  final _RestorationStatus status;
  final dynamic data;
}

class _SettingsPageState extends State<SettingsPage> {
  void _showInfoModal(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
      ),
    );
  }

  Future<bool?> _showConfirmationModal(String title, String content) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text("Proceed"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showRestoreAccountMenu() {
    showDialog<_RestorationResult>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select a backup to restore"),
        content: Text(
            "Your backup must be a csv file containing the list of accounts and their properties that you would like to restore, accounts with the same name as an existing account will be ignored."),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Get the .csv file from the system
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ["csv"],
              );
              if (result != null && result.count > 0) {
                try {
                  List<Account> restored = await restoreAccounts(
                    result,
                    (warning) => _showConfirmationModal("Warning", warning),
                  );

                  Navigator.pop(
                      context,
                      _RestorationResult(
                        _RestorationStatus.Success,
                        restored,
                      ));
                } on BackupException catch (e) {
                  Navigator.pop(
                      context,
                      _RestorationResult(
                        _RestorationStatus.Fail,
                        e.toString(),
                      ));
                }
              } else {
                Navigator.pop(
                    context,
                    _RestorationResult(
                      _RestorationStatus.Cancelled,
                      null,
                    ));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(Icons.upload_file),
                ),
                Text("Choose Backup"),
              ]),
            ),
          ),
        ],
      ),
    ).then((result) {
      if (result == null || result.status == _RestorationStatus.Cancelled) {
      } else if (result.status == _RestorationStatus.Fail) {
        _showInfoModal("Error", result.data as String);
      } else if (result.status == _RestorationStatus.Success) {
        int n = (result.data as List<Account>).length;
        _showInfoModal("Success!", "Restored " + n.toString() + " accounts!");
      }
    });
  }

  void _showRestoreTransactionMenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Not yet implemented"),
      ),
    );
  }

  void _showRestoreMenu() {
    showDialog<_RestoreOption>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Choose Item to Restore"),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(_RestoreOption.Transaction);
            },
            child: Text("Transactions"),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(_RestoreOption.Account);
            },
            child: Text("Accounts"),
          )
        ],
      ),
    ).then((value) {
      if (value != null) {
        if (value == _RestoreOption.Transaction) {
          _showRestoreTransactionMenu();
        } else {
          _showRestoreAccountMenu();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentDateSetting =
    //     DateFormatter.getAvailable(preferences.getString("date_formatter"));
    // print(currentDateSetting);
    return Column(
      children: [
        StandardAppBar(title: "Settings"),
        Padding(
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
                  onPressed: _showRestoreMenu,
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
                    padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: w);
              return Padding(padding: EdgeInsets.only(bottom: 10.0), child: w);
            }).toList(),
          ),
        )
      ],
    );
  }
}
