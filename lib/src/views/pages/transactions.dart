import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/dynamic-scaffold.dart';
import 'package:financier/src/components/fields/payee-payer.dart';
import 'package:financier/src/components/fields/transaction-date.dart';
import 'package:financier/src/components/fields/transaction-details.dart';
import 'package:financier/src/components/fields/transaction-split.dart';
import 'package:financier/src/components/navigation.dart';
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
      Center(child: Text("Transactions")),
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
            ),
            SpeedDialChild(
              child: Icon(Icons.account_balance),
              label: "Checkbook Entry",
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
                    }),
          ],
        ),
      ),
    ]);
  }
}

class TransactionEntry extends StatefulWidget {
  TransactionEntry({Key? key}) : super(key: key);

  @override
  _TransactionEntryState createState() => _TransactionEntryState();
}

class _TransactionEntryState extends State<TransactionEntry> {
  Trans.TransactionBuilder _transaction = Trans.TransactionBuilder();
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  bool _balanced = true;

  void _addTransaction() {
    TransactionActions.manager.newTransaction(_transaction);
  }

  bool _balanceTransaction() {
    double totalCredits = 0;
    double totalDebits = 0;

    for (int i = 0; i < _transaction.debits.length; ++i) {
      totalDebits += _transaction.debits[i].amount;
    }

    for (int i = 0; i < _transaction.credits.length; ++i) {
      totalCredits += _transaction.credits[i].amount;
    }

    print(totalDebits - totalCredits);

    return (totalCredits - totalDebits) == 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget newTransactionForm = Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TransactionDateField(
              _dateController,
              onSaved: (value) => _transaction.date = value,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TransactionDetailsField(
                onSaved: (value) => _transaction.details = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: PayeePayerFormField(
                onSaved: (value) => _transaction.payer = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TransactionSplitField(
                title: "Credits",
                color: Colors.red,
                onSaved: (split) => _transaction.credits.add(split),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: TransactionSplitField(
                title: "Debits",
                color: Colors.black,
                onSaved: (split) => _transaction.debits.add(split),
              ),
            ),
          ],
        ),
      ),
    );

    return newTransactionForm;
  }
}

/*
if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (_balanceTransaction()) {
                setState(() {
                  _balanced = true;
                });
                _addTransaction();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added Transaction')),
                );
              } else {
                setState(() {
                  _balanced = false;
                  _transaction.credits.clear();
                  _transaction.debits.clear();
                });
              }
            }
          }*/