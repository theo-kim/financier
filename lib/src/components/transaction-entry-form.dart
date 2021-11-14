import 'package:pincher/src/components/fields/transaction-type-dropdown.dart';
import 'package:pincher/src/models/timestamp.dart';
import 'package:pincher/src/operations/master.dart';
import 'package:flutter/material.dart';

import 'fields/payee-payer.dart';
import 'fields/transaction-date.dart';
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

  void _submitForm() {
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
  }

  void _addTransaction() {
    app.transactions.newTransaction(_transaction);
  }

  bool _balanceTransaction() {
    double total = 0;

    for (int i = 0; i < _transaction.splits.length; ++i) {
      total += _transaction.splits[i].amount *
          (_transaction.splits[i].type == Trans.TransactionSplitType.credit
              ? -1
              : 1);
    }

    return total == 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget newTransactionForm = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Record Manual Transaction",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.start,
          ),
          TransactionDateField(
            _dateController,
            onChanged: (DateTime? value) {
              setState(() =>
                  _transaction.date = BuiltTimestampBuilder()..date = value);
            },
          ),
          TransactionTypeField(
            onChanged: (t) => setState(() => _transaction.type = t),
            errorMessage: "You must specify a transaction type",
            label: "Transaction Type",
          ),
          PayeePayerFormField(
            onChanged: (value) => setState(() => _transaction.payer = value),
          ),
          TransactionSplitField(
            title: "Splits",
            color: Colors.black,
            onChanged: (value) {
              _transaction.splits = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Text(
                      "Cancel",
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _submitForm,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  padding: EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Text(
                    "Record",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ]
            .map<Widget>(
              (e) => Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: e,
              ),
            )
            .toList(),
      ),
    );

    return newTransactionForm;
  }
}
