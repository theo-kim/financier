import 'package:dropdown_search/dropdown_search.dart';
import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/operations/master.dart';
import 'package:flutter/material.dart';

class AccountDropdownField extends StatefulWidget {
  AccountDropdownField({
    required this.onChanged,
    required this.errorMessage,
    required this.label,
    this.required = true,
    this.initialValue,
  });

  final void Function(Account?) onChanged;
  final String errorMessage;
  final String label;
  final bool required;
  final String? initialValue;

  @override
  _AccountDropdownFieldState createState() => _AccountDropdownFieldState();
}

class _AccountDropdownFieldState extends State<AccountDropdownField> {
  List<Account> _accounts = <Account>[];

  Future<List<Account>> _findAccount(String filter) async {
    List<Account> results = [];
    for (int i = 0; i < _accounts.length; ++i) {
      if (_accounts[i].toString().contains(filter) &&
          _accounts[i].type != AccountType.none) {
        results.add(_accounts[i]);
      }
    }
    return results;
  }

  @override
  void initState() {
    super.initState();
    app.accounts.getAllAccounts().then((accounts) {
      setState(() {
        _accounts = accounts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Account? initial;
    try {
      initial = _accounts.firstWhere((a) => a.id == widget.initialValue);
    } on StateError {
      initial = null;
    }

    return DropdownSearch<Account>(
      selectedItem: widget.initialValue == null ? null : initial,
      validator: (Account? account) {
        if (widget.required && account == null) {
          return widget.errorMessage;
        }
        return null;
      },
      onChanged: widget.onChanged,
      showClearButton: true,
      autoFocusSearchBox: true,
      showSearchBox: true,
      mode: Mode.BOTTOM_SHEET,
      label: widget.label,
      onFind: (String filter) => _findAccount(filter),
      itemAsString: (Account a) => a.name,
    );
  }
}
