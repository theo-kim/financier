import 'package:financier/src/operations/transactions.dart';
import 'package:flutter/material.dart';

import 'fields/payee-payer.dart';
import 'fields/transaction-date.dart';
import 'fields/transaction-details.dart';
import 'fields/transaction-split.dart';
import '../models/transaction.dart' as Trans;

class TransactionEntry extends StatefulWidget {
  TransactionEntry({Key? key}) : super(key: key);

  @override
  _TransactionEntryState createState() => _TransactionEntryState();
}

class _TransactionEntryState extends State<TransactionEntry> {
  Trans.TransactionBuilder _transaction = Trans.TransactionBuilder();
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

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
            TransactionDetailsField(
              onSaved: (value) => _transaction.details = value,
            ),
            PayeePayerFormField(
              onSaved: (value) => _transaction.payer = value,
            ),
            TransactionSplitField(
              title: "Credits",
              color: Colors.red,
              onSaved: (split) => _transaction.credits.add(split),
            ),
            TransactionSplitField(
              title: "Debits",
              color: Colors.black,
              onSaved: (split) => _transaction.debits.add(split),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (_balanceTransaction()) {
                    _addTransaction();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added Transaction')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                            "Your transaction is unbalanced, ensure your credits and debits balances to zero."),
                      ),
                    );
                    setState(() {
                      _transaction.credits.clear();
                      _transaction.debits.clear();
                    });
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.receipt_long_rounded),
                    ),
                    Text("Record Transaction",
                        style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            )
          ]
              .map<Widget>(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: e,
                ),
              )
              .toList(),
        ),
      ),
    );

    return newTransactionForm;
  }
}
