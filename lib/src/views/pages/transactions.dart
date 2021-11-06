import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/transaction-entry-form.dart';
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/master.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tuple/tuple.dart';

import '../../models/transaction.dart' as Trans;

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
        child: TransactionEntry(
          onSubmit: () {
            Navigator.of(context).pop();
            _reload();
          },
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StandardAppBar(title: "Transactions"),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  elevation: 6,
                  child: FutureBuilder(
                    future: app.transactions.getAllTransactions(),
                    builder: (context,
                        AsyncSnapshot<List<Trans.Transaction>> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.stackTrace);
                        return _errorContainer("Error loading transactions: " +
                            snapshot.error.toString());
                      } else if (!snapshot.hasData ||
                          snapshot.data!.length == 0) {
                        return _errorContainer(
                            "Could not find any transactions, try creating one");
                      } else {
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
                      }
                    },
                  ),
                ),
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
          ),
        )
      ],
    );
  }
}

class TransactionList extends StatefulWidget {
  TransactionList(this.transactions);

  final List<Trans.Transaction> transactions;

  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  int dateSort = 1;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      onSelectAll: (b) {},
      headingRowColor: MaterialStateProperty.all<Color>(Color(0xfff0f0f0)),
      columns: <DataColumn>[
        DataColumn(label: Text("Type")),
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
      rows: widget.transactions
          .fold<List<Tuple2<Transaction, TransactionSplit>>>(
            [],
            (prev, el) => prev +
                el.splits
                    .toList()
                    .map<Tuple2<Transaction, TransactionSplit>>(
                      (s) => Tuple2<Transaction, TransactionSplit>(el, s),
                    )
                    .toList()
              ..sort((a, b) =>
                  dateSort * a.item1.date.date.compareTo(b.item1.date.date)),
          )
          .map<DataRow>((s) => TransactionRow(s.item2, s.item1))
          .toList(),
    );
  }
}

class TransactionRow extends DataRow {
  TransactionRow(this.split, this.transaction)
      : super(
          cells: [
            Text(transaction.type.toString().replaceAll("_", " ")),
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
          onSelectChanged: (bool? value) {},
        );

  final TransactionSplit split;
  final Transaction transaction;
}
