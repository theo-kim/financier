import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/components/fields/payee-payer.dart';
import 'package:financier/src/components/fields/transaction-date.dart';
import 'package:financier/src/components/fields/transaction-details.dart';
import 'package:financier/src/components/fields/transaction-split.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:flutter/material.dart';
import '../components/navigation.dart';
import '../../models/transaction.dart' as Trans;

// TODO: https://github.com/material-components/material-components-flutter-adaptive/blob/develop/adaptive_navigation/example/lib/default_scaffold.dart

class EntryPage extends StatefulWidget {
  EntryPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
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
    Widget transactionStatusMessage = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
            width: 2, color: (_balanced ? Colors.green : Colors.orange)),
      ),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          (_balanced
              ? "Your transaction is currently balanced"
              : "Your transaction is unbalanced"),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: (_balanced ? Colors.green : Colors.orange),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    Widget newTransactionForm = Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            transactionStatusMessage,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavigationDrawer(activePage: widget.title),
      body: SingleChildScrollView(child: newTransactionForm),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        },
        tooltip: 'Submit',
        child: Icon(Icons.save_rounded),
      ),
    );
  }
}
