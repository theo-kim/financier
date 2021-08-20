import 'package:dropdown_search/dropdown_search.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:flutter/material.dart';

typedef void onSavedFunction(TransactionSplit split);

class TransactionSplitField extends StatefulWidget {
  TransactionSplitField(
      {required this.title, required this.color, required this.onSaved});

  final String title;
  final Color color;
  final onSavedFunction onSaved;

  @override
  State<StatefulWidget> createState() => _TransactionSplitFieldState();
}

class _TransactionSplitFieldState extends State<TransactionSplitField> {
  final _entries = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: widget.color, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_entries.length} ${widget.title}",
                      style: TextStyle(
                        color: widget.color,
                        fontSize: 16.0,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _entries.add(SplitEntry(
                            index: _entries.length - 1,
                            onSave: widget.onSaved,
                          ));
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        size: 16.0,
                      ),
                      label: Text("Add Credit"),
                    )
                  ],
                )
              ] +
              List.generate(_entries.length, (index) => _entries[index]),
        ),
      ),
    );
  }
}

class SplitEntry extends StatefulWidget {
  SplitEntry({Key? key, required this.index, required this.onSave})
      : super(key: key);

  final int index;
  final onSavedFunction onSave;

  @override
  _SplitEntryState createState() => _SplitEntryState();
}

class _SplitEntryState extends State<SplitEntry> {
  double? _value;
  Account? _account;
  int _updated = 0;
  List<Account> _accounts = <Account>[];

  @override
  void initState() {
    super.initState();
    AccountActions.manager.getAllAccounts().then((accounts) {
      setState(() {
        _accounts = accounts;
      });
    });
  }

  Future<List<Account>> _findAccount(String filter) async {
    List<Account> results = [];
    for (int i = 0; i < _accounts.length; ++i) {
      if (_accounts[i].toString().contains(filter)) {
        results.add(_accounts[i]);
      }
    }
    return results;
  }

  void _saveState() {
    if (_updated > 0 && _account != null && _value != null) {
      final split = TransactionSplitBuilder();

      split.account = _account!.id.toBuilder();
      split.amount = _value;

      widget.onSave(split.build());

      _updated = 0;
    } else {
      _updated++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: TextFormField(
                validator: (value) {
                  if (double.tryParse(value as String) == null) {
                    return "Amounts must be a number";
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _value = double.parse(value!);
                  _saveState();
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Amount",
                  labelStyle: TextStyle(fontSize: 16.0),
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Colors.black,
                    size: 16.0,
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            Spacer(flex: 1),
            Flexible(
              flex: 7,
              child: DropdownSearch<Account>(
                validator: (Account? account) {
                  if (account == null) {
                    return "You must assign an account to your transaction";
                  }
                  return null;
                },
                onSaved: (Account? account) {
                  _account = account!;
                  _saveState();
                },
                autoFocusSearchBox: true,
                showSearchBox: true,
                mode: Mode.BOTTOM_SHEET,
                label: "Account",
                onFind: (String filter) => _findAccount(filter),
                itemAsString: (Account a) => a.name,
              ),
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.remove_circle,
                  size: 16.0,
                ),
              ),
            ),
          ]),
    );
  }
}
