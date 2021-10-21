import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/timestamp.dart';
import 'package:financier/src/operations/master.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:flutter/material.dart';

import 'fields/payee-payer.dart';
import 'fields/transaction-date.dart';
import 'fields/transaction-details.dart';
import 'fields/transaction-split.dart';
import '../models/transaction.dart' as Trans;

class TransactionEntry extends StatefulWidget {
  TransactionEntry({Key? key, required this.onSubmit}) : super(key: key);

  final Function() onSubmit;

  @override
  _TransactionEntryState createState() => _TransactionEntryState();
}

class _TransactionEntryState extends State<TransactionEntry> {
  Trans.TransactionBuilder _transaction = Trans.TransactionBuilder();
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  void _addTransaction() {
    app.transactions.newTransaction(_transaction);
  }

  bool _balanceTransaction() {
    double total = 0;

    for (int i = 0; i < _transaction.splits.length; ++i) {
      total += _transaction.splits[i].amount;
    }

    return total == 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget newTransactionForm = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TransactionDateField(
              _dateController,
              onChanged: (DateTime? value) => setState(() =>
                  _transaction.date = BuiltTimestampBuilder()..date = value),
            ),
            // TransactionDetailsField(
            //   onChanged: (String? value) =>
            //       setState(() => _transaction.details = value),
            // ),
            PayeePayerFormField(
              onChanged: (value) => setState(() => _transaction.payer = value),
            ),
            TransactionSplitField(
              title: "Splits",
              color: Colors.black,
              onChanged: (value) => _transaction.splits = value,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_balanceTransaction()) {
                    _addTransaction();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added Transaction')),
                    );
                    widget.onSubmit();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                            "Your transaction is unbalanced, ensure your credits and debits balances to zero."),
                      ),
                    );
                    setState(() {
                      _transaction.splits.clear();
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
