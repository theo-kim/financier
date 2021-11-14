import 'package:pincher/src/components/datatable.dart';
import 'package:pincher/src/components/transaction-entry-form.dart';
import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/models/transaction.dart';
import 'package:pincher/src/operations/date.dart';
import 'package:pincher/src/operations/master.dart';
import 'package:pincher/src/operations/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../models/transaction.dart' as Trans;

extension StringExtension on String {
  String capitalizeMulti() {
    return this
        .split(" ")
        .map<String>((w) => "${w[0].toUpperCase()}${w.substring(1)}")
        .toList()
        .join(" ");
  }
}

// TODO: https://github.com/material-components/material-components-flutter-adaptive/blob/develop/adaptive_navigation/example/lib/default_scaffold.dart

class _NewLedgerEntryIntent extends Intent {}

class TransactionPageIntent extends Intent {}

class TransactionPage extends StatefulWidget {
  TransactionPage();

  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  final newLedgerEntryKeySet =
      LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyL);

  void _reload() {
    setState(() {});
  }

  void _showLedgerEntryForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
              child: TransactionEntry(
                onSubmit: () {
                  Navigator.of(context).pop();
                  _reload();
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _errorContainer(String errorText) {
    return Container(
      child: Center(
        child: Text(errorText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder(
          future: app.transactions.getAllTransactions(),
          builder: (context, AsyncSnapshot<List<Trans.Transaction>> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.stackTrace);
              return _errorContainer(
                  "Error loading transactions: " + snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.length == 0) {
              return _errorContainer(
                  "Could not find any transactions, try creating one");
            } else if (snapshot.hasData) {
              return FocusableActionDetector(
                autofocus: true,
                shortcuts: {
                  newLedgerEntryKeySet: _NewLedgerEntryIntent(),
                },
                actions: {
                  _NewLedgerEntryIntent: CallbackAction(
                    onInvoke: (e) => _showLedgerEntryForm.call(),
                  ),
                },
                child: TransactionList(snapshot.data!),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: SpeedDial(
            icon: Icons.add,
            tooltip: "Add Transaction",
            children: [
              SpeedDialChild(
                child: Icon(Icons.credit_card_rounded),
                label: "Enter Credit Card Charge",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Not yet implemented, use \"Manual Ledge Entry\" Option"),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.account_balance),
                label: "Checkbook Entry",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Not yet implemented, use \"Manual Ledge Entry\" Option"),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.book),
                label: "Manual Ledger Entry",
                onTap: _showLedgerEntryForm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TransactionList extends StatefulWidget {
  TransactionList(this.transactions);

  final List<Trans.Transaction>? transactions;

  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  int dateSort = 1;
  bool _showCheckbox = false;
  Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    List<TransactionRow> rows = [];
    int currentIndex = 0;
    int maxIndex = 0;

    bool isSmol = MediaQuery.of(context).size.width < 700;

    for (Transaction t in widget.transactions!) {
      for (TransactionSplit s in t.splits) {
        rows.add(
          TransactionRow(
            currentIndex,
            s,
            t,
            selected: selected.contains(currentIndex),
            isSmol: isSmol,
            onTap: (int s, bool b) {
              setState(() {
                if (b) {
                  selected.add(s);
                  _showCheckbox = true;
                } else {
                  selected.remove(s);
                  if (selected.length == 0) {
                    _showCheckbox = false;
                  }
                }
              });
            },
          ),
        );
        currentIndex++;
      }
    }

    maxIndex = currentIndex;

    return FormattedDataTable(
      isMain: isSmol,
      compress: isSmol,
      title: "Transactions",
      onDelete: () {
        selected.forEach((element) {});
      },
      maxWidth: 1000,
      filters: [
        FilterOptions<TransactionType>(
          name: "Type",
          options: TransactionType.values.toList(),
          readable: (t) => t.toString(),
          onFiltered: (v) {},
        ),
        FilterOptions<Account>(
          name: "Account",
          options: app.accounts.getAllCachedAccounts(),
          readable: (a) => a.name,
          onFiltered: (v) {},
        )
      ],
      checkboxHorizontalMargin: 10,
      showCheckboxColumn: _showCheckbox,
      onSelectAll: (b) {
        if (b != null && b == true) {
          Set<int> s = {};
          for (int i = 0; i < maxIndex; ++i) {
            s.add(i);
          }
          setState(() {
            selected.addAll(s);
          });
        } else {
          setState(() {
            selected.clear();
            _showCheckbox = false;
          });
        }
      },
      headingRowColor: Color(0xfff0f0f0),
      columns: <DataColumn>[
        if (!isSmol) DataColumn(label: Text("Type")),
        DataColumn(
            label: Text("Date"),
            onSort: (indx, asc) {
              setState(() {
                dateSort = dateSort * -1;
              });
            }),
        DataColumn(label: Text("Account")),
        DataColumn(label: Text("Amount"), numeric: true),
      ],
      rows: rows,
    );
  }
}

class TransactionRow extends DataRow {
  TransactionRow(this.index, this.split, this.transaction,
      {required this.onTap, this.selected = false, bool isSmol = false})
      : super(
          selected: selected,
          onSelectChanged: (selected) => onTap(index, selected!),
          cells: [
            if (!isSmol)
              Text(transaction.type
                  .toString()
                  .replaceAll("_", " ")
                  .capitalizeMulti()),
            Text(DateFormatter.getAvailable(
                    preferences.getString("date_formatter"))
                .formatDate(transaction.date.date)),
            Text(app.accounts.getCachedAccountByReference(split.account).name),
            Text(
              "\$" + split.amount.toStringAsFixed(2),
              style: TextStyle(
                color: split.type == TransactionSplitType.credit
                    ? Colors.red
                    : Colors.black,
              ),
            )
          ]
              .map<DataCell>(
                (e) => DataCell(
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: e,
                  ),
                ),
              )
              .toList(),
        );

  final TransactionSplit split;
  final Transaction transaction;
  final Function(int, bool) onTap;
  final bool selected;
  final int index;
}
