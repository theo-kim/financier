import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/dynamic-scaffold.dart';
import 'package:financier/src/components/fields/payee-payer.dart';
import 'package:financier/src/components/fields/transaction-date.dart';
import 'package:financier/src/components/fields/transaction-details.dart';
import 'package:financier/src/components/fields/transaction-split.dart';
import 'package:financier/src/components/navigation.dart';
import 'package:financier/src/components/transaction-entry-form.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:financier/src/views/pages/adaptive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../models/transaction.dart' as Trans;

// TODO: https://github.com/material-components/material-components-flutter-adaptive/blob/develop/adaptive_navigation/example/lib/default_scaffold.dart

class TransactionPage extends StatefulWidget {
  TransactionPage();

  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder(
        future: TransactionActions.manager.getAllTransactions(),
        builder: (context, AsyncSnapshot<List<Trans.Transaction>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: Text("Could not load accounts"),
              ),
            );
          } else if (snapshot.data!.length == 0) {
            return Container(
              child: Center(
                child: Text("Could not find any accounts, try creating one"),
              ),
            );
          } else {
            return TransactionList(snapshot.data!);
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
              onTap: () => {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: true,
                  builder: (context) =>
                      SingleChildScrollView(child: TransactionEntry()),
                )
              },
            ),
          ],
        ),
      ),
    ]);
  }
}

class TransactionList extends StatefulWidget {
  TransactionList(this.transactions);

  List<Trans.Transaction> transactions;

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
                  child: Padding(
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
    return Material(
      child: ListTile(
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        title: Row(
          children: <String, int>{
            "Check": 1,
            "1 December 1970": 1,
            "Checkings Account": 2,
            "\$18.00": 1,
          }
              .entries
              .map<Widget>(
                (e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(e.key, style: TextStyle(fontSize: 14.0)),
                  ),
                  flex: e.value,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
