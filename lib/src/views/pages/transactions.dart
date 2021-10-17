import 'package:financier/src/components/transaction-entry-form.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/operations/date.dart';
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
        future: TransactionActions.manager.getAllTransactions(),
        builder: (context, AsyncSnapshot<List<Trans.Transaction>> snapshot) {
          if (snapshot.hasError) {
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

class TransactionListing extends StatelessWidget {
  TransactionListing({required this.transaction});

  final Trans.Transaction transaction;

  @override
  Widget build(BuildContext context) {
    String? formatterName = preferences.getString("date_formatter");
    DateFormatter formatter = DateFormatter.getAvailable(formatterName);

    return Material(
      child: ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.zero,
        title: Column(
          children: (transaction.credits + transaction.debits)
              .map<Widget>(
                (e) => Row(
                  children: <String, int>{
                    (transaction.type != null
                        ? transaction.type.toString()
                        : "Transfer"): 1,
                    formatter.formatDate(transaction.date): 1,
                    AccountActions.manager
                        .getCachedAccountByReference(e.account.reference!)
                        .name: 2,
                    (transaction.credits.indexOf(e) >= 0
                        ? (-1 * e.amount)
                            .toString() // TODO: How many decimal places to show for doubles?
                        : e.amount.toString()): 1,
                  }
                      .entries
                      .map<Widget>(
                        (e) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child:
                                Text(e.key, style: TextStyle(fontSize: 14.0)),
                          ),
                          flex: e.value,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
