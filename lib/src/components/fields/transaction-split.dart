import 'package:built_collection/built_collection.dart';
import 'package:pincher/src/components/fields/account-dropdown.dart';
import 'package:pincher/src/components/fields/currency.dart';
import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionSplitField extends StatefulWidget {
  TransactionSplitField({
    required this.title,
    required this.color,
    required this.onChanged,
  });

  final String title;
  final Color color;
  final Function(ListBuilder<TransactionSplit>) onChanged;

  @override
  State<StatefulWidget> createState() => _TransactionSplitFieldState();
}

class _TransactionSplitFieldState extends State<TransactionSplitField> {
  final ListBuilder<TransactionSplitBuilder> _splits =
      ListBuilder<TransactionSplitBuilder>();

  // Only pass along completed splits
  void _commitChange() {
    ListBuilder<TransactionSplit> commit = ListBuilder<TransactionSplit>();

    for (int i = 0; i < _splits.length; ++i) {
      // Ignore failed builds
      try {
        commit.add(_splits[i].build());
      } catch (e) {}
    }

    widget.onChanged(commit);
  }

  void _removeEntry(int i) {
    setState(() {
      _splits.removeAt(i);
      _commitChange();
    });
  }

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
                        "${_splits.length} ${widget.title}",
                        style: TextStyle(
                          color: widget.color,
                          fontSize: 16.0,
                        ),
                      ),
                      Row(children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _splits.add(TransactionSplitBuilder()
                                ..type = TransactionSplitType.credit);
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: 16.0,
                          ),
                          label: Text("Credit"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _splits.add(TransactionSplitBuilder()
                                  ..type = TransactionSplitType.debit);
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                            label: Text("Debit"),
                          ),
                        ),
                      ]),
                    ],
                  )
                ] +
                [for (int i = 0; i < _splits.length; ++i) i]
                    .map<SplitEntry>((i) => SplitEntry(
                          onChanged: (e) => setState(() {
                            _splits[i] = e;
                            _commitChange();
                          }),
                          onRemove: () => _removeEntry(i),
                          type: _splits[i].type!,
                        ))
                    .toList()),
      ),
    );
  }
}

class SplitEntry extends StatefulWidget {
  SplitEntry({
    Key? key,
    required this.onChanged,
    required this.onRemove,
    required this.type,
  }) : super(key: key);

  final Function(TransactionSplitBuilder) onChanged;
  final Function() onRemove;
  final TransactionSplitType type;

  @override
  _SplitEntryState createState() => _SplitEntryState();
}

class _SplitEntryState extends State<SplitEntry> {
  TransactionSplitBuilder _split = TransactionSplitBuilder();

  @override
  void initState() {
    _split.type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: CurrencyField(
                  label: "Amount",
                  required: true,
                  onChanged: (double amount) {
                    widget.onChanged(_split..amount = amount);
                  },
                  color: _split.type == TransactionSplitType.credit
                      ? Colors.red
                      : Colors.black,
                  errorMessage:
                      'You need to specify a value for this transaction',
                ),
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 7,
                child: AccountDropdownField(
                  label: "Account",
                  onChanged: (Account? a) {
                    if (a == null) {
                      widget.onChanged(_split..account = null);
                    } else {
                      widget.onChanged(_split..account = a.id);
                    }
                  },
                  required: true,
                  errorMessage:
                      "You must assign an account to this transaction",
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () => widget.onRemove(),
                  icon: Icon(
                    Icons.remove_circle,
                    size: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
