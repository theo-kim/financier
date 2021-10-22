import 'package:dropdown_search/dropdown_search.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/operations/master.dart';
import 'package:flutter/material.dart';

class TransactionTypeField extends StatefulWidget {
  TransactionTypeField(
      {required this.onChanged,
      required this.errorMessage,
      required this.label,
      this.required = true});

  final void Function(TransactionType?) onChanged;
  final String errorMessage;
  final String label;
  final bool required;

  @override
  _TransactionTypeFieldState createState() => _TransactionTypeFieldState();
}

class _TransactionTypeFieldState extends State<TransactionTypeField> {
  List<TransactionType> _types = TransactionType.values.toList();
  // .map<String>((t) => t.toString().replaceAll("_", " "))
  // .toList();

  Future<List<TransactionType>> _findType(String filter) async {
    List<TransactionType> results = [];
    for (int i = 0; i < _types.length; ++i) {
      if (_types[i].toString().replaceAll("_", " ").contains(filter)) {
        results.add(_types[i]);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<TransactionType>(
      validator: (TransactionType? type) {
        if (widget.required && type == null) {
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
      onFind: (String filter) => _findType(filter),
      itemAsString: (TransactionType t) => t.toString().replaceAll("_", " "),
    );
  }
}
