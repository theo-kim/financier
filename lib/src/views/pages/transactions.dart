import 'package:financier/src/components/transaction-entry-form.dart';
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/operations/date.dart';
import 'package:financier/src/operations/master.dart';
import 'package:financier/src/operations/preferences.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
    return Stack(children: [
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
    ]);
  }
}

class TransactionList extends StatefulWidget {
  TransactionList(this.transactions);

  final List<Trans.Transaction> transactions;

  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: <String, int>{
            "Type": 1,
            "Date": 1,
            "Account": 2,
            "Amount": 1,
          }
              .entries
              .map<Widget>(
                (e) => Expanded(
                  child: Container(
                    color: Color(0xfff0f0f0),
                    padding: EdgeInsets.all(10.0),
                    child: Text(e.key),
                  ),
                  flex: e.value,
                ),
              )
              .toList(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.transactions.length,
            itemBuilder: (BuildContext context, int index) {
              return TransactionListing(
                transaction: widget.transactions[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TransactionRow extends StatelessWidget {
  TransactionRow(this.transaction, this.split)
      : _formatter =
            DateFormatter.getAvailable(preferences.getString("date_formatter"));

  final Transaction transaction;
  final TransactionSplit split;
  final DateFormatter _formatter;

  Widget _cell(Text contents, int flex) => Expanded(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: contents,
        ),
        flex: flex,
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _cell(Text(transaction.type.toString().replaceAll("_", " ")), 1),
      _cell(Text(_formatter.formatDate(transaction.date.date)), 1),
      _cell(Text(app.accounts.getCachedAccountByReference(split.account).name),
          2),
      _cell(
          Text(
            "\$" + split.amount.toStringAsFixed(2),
            style: TextStyle(
              color: split.type == TransactionSplitType.credit
                  ? Colors.red
                  : Colors.black,
            ),
          ),
          1),
    ]);
  }
}

class TransactionListing extends StatelessWidget {
  TransactionListing({required this.transaction});

  final Trans.Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.zero,
        title: Column(
          children: (transaction.splits)
              .map<Widget>((e) => TransactionRow(transaction, e))
              .toList(),
        ),
      ),
    );
  }
}
