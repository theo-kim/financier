import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/components/fields/account-dropdown.dart';
import 'package:financier/src/components/fields/currency.dart';
import 'package:financier/src/components/fields/standard-field.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class AccountsPage extends StatefulWidget {
  AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  AccountType? _filteredType;
  final GlobalKey<_AccountListState> _accountList =
      GlobalKey<_AccountListState>();

  void _saveAccount(Account newAccount, Account? parent, BuildContext context) {
    AccountActions.manager.newAccount(newAccount.toBuilder()).then((child) {
      if (parent != null) {
        AccountActions.manager.addChildAccount(parent, child);
      } else {
        AccountActions.manager.getRootAccount().then((Account root) {
          AccountActions.manager.addChildAccount(root, child).then((_) {
            Navigator.of(context).pop();
            _accountList.currentState!.reload();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AccountList(_filteredType, key: _accountList),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: FloatingActionButton(
            tooltip: 'New Account',
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => NewAccountForm(
                    onSubmit: (n, p) => _saveAccount(n, p, context)),
                isScrollControlled: true,
                enableDrag: true,
              );
            },
          ),
        )
      ],
    );
  }
}

class AccountList extends StatefulWidget {
  AccountList(this.type, {required this.key});

  final AccountType? type;
  final GlobalKey<_AccountListState> key;

  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: widget.type == null
          ? AccountActions.manager.getAllAccounts()
          : AccountActions.manager.getAccountsByType(widget.type!),
      builder: (context, snapshot) {
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
        }
        List<Account> accounts = <Account>[
          for (var account in snapshot.data!)
            if (account.type != AccountType.none) account
        ];
        return ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            return AccountListing(account: accounts[index]);
          },
        );
      },
    );
  }
}

class AccountListing extends StatelessWidget {
  AccountListing({required this.account});

  final Account account;

  Container _accountTypeBadgeGen(AccountType t) {
    late Color backgroundColor;

    switch (t) {
      case AccountType.asset:
        backgroundColor = Colors.blue;
        break;
      case AccountType.liability:
        backgroundColor = Colors.orange;
        break;
      case AccountType.income:
        backgroundColor = Colors.green;
        break;
      case AccountType.expense:
        backgroundColor = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
          border: Border.all(color: backgroundColor, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Center(
        child:
            Text(t.toString().capitalize(), style: TextStyle(fontSize: 12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(account.name),
              _accountTypeBadgeGen(account.type)
            ])
          ]),
    ));
  }
}

class NewAccountForm extends StatelessWidget {
  NewAccountForm({required this.onSubmit});

  final void Function(Account newAccount, Account? parent) onSubmit;

  final _formKey = GlobalKey<FormState>();
  final _account = AccountBuilder();
  late final Account? _parentAccount;

  void _saveParentAccount(Account? a) {
    _parentAccount = a;
    if (a != null) _account.type = a.type;
  }

  void _submitAccount(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_parentAccount != null && _parentAccount!.type != _account.type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "This account must be the same type as the specified parent account."),
            backgroundColor: Colors.red,
          ),
        );
      }
      onSubmit(_account.build(), _parentAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
                  AccountPropertyField(
                    name: "Account Name",
                    errorMessage: "Account name is required",
                    onSaved: (String? value) => _account.name = value!,
                  ),
                  AccountPropertyField(
                    name: "Account Memo",
                    required: false,
                    errorMessage: "",
                    onSaved: (String? value) => _account.memo = value,
                  ),
                  CurrencyField(
                    errorMessage: '',
                    required: false,
                    label: 'Starting Balance',
                    onSaved: (double amount) {
                      _account.startingBalance = amount;
                    },
                  ),
                  AccountDropdownField(
                    label: "Parent Account",
                    onSaved: _saveParentAccount,
                    errorMessage: "",
                    required: false,
                  ),
                  DropdownButtonFormField(
                    onChanged: (a) {},
                    validator: (t) =>
                        t == null ? "You must specify an account type" : null,
                    onSaved: (AccountType? type) => _account.type = type,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Account Type",
                      labelStyle: TextStyle(fontSize: 16.0),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    items: <AccountType>[
                      AccountType.expense,
                      AccountType.income,
                      AccountType.liability,
                      AccountType.asset,
                    ]
                        .map<DropdownMenuItem<AccountType>>((e) =>
                            DropdownMenuItem(
                                value: e,
                                child: Text(e.toString().capitalize())))
                        .toList(),
                  ),
                ]
                    .map<Widget>(
                        (e) => Padding(padding: EdgeInsets.all(10.0), child: e))
                    .toList() +
                <Widget>[
                  ElevatedButton(
                    onPressed: () => _submitAccount(context),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                ],
          ),
        ),
      ),
    );
  }
}

class AccountPropertyField extends StandardFormField {
  AccountPropertyField(
      {required this.name,
      required this.errorMessage,
      this.validator,
      required onSavedFunction onSaved,
      bool required = true})
      : super(required, onSaved);

  final String name;
  final String errorMessage;
  final bool Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String? value) {
        if ((this.required && (value == null || value.length == 0)) ||
            (this.validator != null && !this.validator!(value))) {
          return this.errorMessage;
        }
        return null;
      },
      onSaved: this.onSaved,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.name,
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
