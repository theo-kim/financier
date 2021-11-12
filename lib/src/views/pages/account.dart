import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/fields/account-dropdown.dart';
import 'package:financier/src/components/fields/currency.dart';
import 'package:financier/src/components/fields/standard-field.dart';
import 'package:financier/src/components/fields/tag-adder.dart';
import 'package:financier/src/components/modal.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/accounttags.dart';
import 'package:financier/src/operations/master.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class AccountPageIntent extends Intent {}

class _NewAccountIntent extends Intent {}

class AccountsPage extends StatefulWidget {
  AccountsPage() : super();

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  AccountType? _filteredType;
  final GlobalKey<_AccountListState> _accountList =
      GlobalKey<_AccountListState>();

  final LogicalKeySet _newAccountShortcut =
      LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyN);

  void _showNewAccountForm() {
    showDialog(
      context: context,
      builder: (context) =>
          NewAccountForm(onSubmit: (n, p) => _saveAccount(n, p, context)),
    );
  }

  void _saveAccount(
      AccountBuilder newAccount, Account? parent, BuildContext ctx) async {
    try {
      await app.accounts.newAccount(newAccount);
      Navigator.of(ctx).pop();
      _accountList.currentState!.reload();
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text("Error while creating account: " + e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        StandardAppBar(title: "Accounts"),
        Expanded(
          child: Stack(
            children: <Widget>[
              FocusableActionDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      color: Color(0xfffafafa),
                      child: AccountList(
                        type: _filteredType,
                        key: _accountList,
                        title: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Accounts"),
                        ),
                      ),
                    ),
                  ),
                ),
                shortcuts: {
                  _newAccountShortcut: _NewAccountIntent(),
                },
                autofocus: true,
                actions: {
                  _NewAccountIntent: CallbackAction(
                    onInvoke: (e) => _showNewAccountForm(),
                  ),
                },
              ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: FloatingActionButton(
                  tooltip: 'New Account',
                  child: Icon(Icons.add),
                  onPressed: _showNewAccountForm,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AccountList extends StatefulWidget {
  AccountList({
    this.type,
    this.parent,
    required this.title,
    required this.key,
    this.errorMsg = "Error loading accounts",
    this.emptyMsg = "Could not find any account, try creating one",
    this.msgAlignment = TextAlign.center,
  });

  final AccountType? type;
  final Account? parent;
  final GlobalKey<_AccountListState> key;
  final String errorMsg;
  final String emptyMsg;
  final TextAlign msgAlignment;
  final Widget title;

  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  void reload() {
    setState(() {});
  }

  Widget _errorContainer(
    String errorText, {
    TextAlign textAlign = TextAlign.center,
  }) {
    return Container(
      child: Text(
        errorText,
        textAlign: textAlign,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: widget.type == null
          ? (widget.parent == null
              ? app.accounts.getAllRootAccounts()
              : app.accounts.getAccountsByParent(widget.parent!))
          : app.accounts.getAccountsByType(widget.type!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorContainer(
            widget.errorMsg + " (" + snapshot.error.toString() + ")",
            textAlign: widget.msgAlignment,
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.length == 0) {
          return _errorContainer(
            widget.emptyMsg,
            textAlign: widget.msgAlignment,
          );
        }
        List<Account> accounts = snapshot.data!;
        return Column(
          children: [
            Row(
              children: [
                widget.title,
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.sort_by_alpha, size: 20),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return AccountListing(
                  accountList: widget.key,
                  account: accounts[index],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class AccountListing extends StatelessWidget {
  AccountListing({required this.account, required this.accountList});

  final Account account;
  final GlobalKey<_AccountListState> accountList;

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
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Material(
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(left: 20.0, right: 20.0),
          textColor: Colors.black,
          iconColor: Colors.black,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(account.name), _accountTypeBadgeGen(account.type)],
          ),
          backgroundColor: Color(0xfffafafa),
          children: [
            AccountDetails(
              account: this.account,
              context: context,
              accountList: this.accountList,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountDetails extends StatelessWidget {
  AccountDetails({
    required this.account,
    required this.context,
    required this.accountList,
  });

  final Account account;
  final BuildContext context;
  final GlobalKey<_AccountListState> accountList;

  final GlobalKey<_AccountListState> _childList =
      GlobalKey<_AccountListState>();

  void _deleteAccount() async {
    bool? confirm = await showDialog<bool>(
      context: this.context,
      builder: (ctx) => AlertDialog(
          content: (app.accounts.computeAccountChildren(this.account) > 0)
              ? Text(
                  "Are you sure you want to delete this account? This account has children, they will be made children to its parent account.")
              : Text("Are you sure you want to delete this account?"),
          actions: [
            TextButton(
              child: Text("Yes", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.pop(ctx, true),
            ),
            TextButton(
              child: Text("No", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(ctx, false),
            )
          ]),
    );
    if (confirm != null && confirm) {
      await app.accounts.deleteAccount(account);
      Navigator.pop(context);
      accountList.currentState!.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (account.memo != null && account.memo!.length > 1)
            Text("Account memo: " + account.memo!),
          Row(
              children: <Widget>[Text("Tags: ")] +
                  account.tags
                      .map<Widget>(
                        (t) => Chip(
                          label: Text(t.toString().replaceAll("_", " ")),
                        ),
                      )
                      .toList()),
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: _deleteAccount,
                      icon: Icon(Icons.delete),
                      label: Text("Delete Account"),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xffe0e0e0)),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                      label: Text("Edit Account"),
                    ),
                  ]
                      .map<Widget>((e) => Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: e,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          AccountList(
            parent: account,
            key: _childList,
            emptyMsg: "No children",
            msgAlignment: TextAlign.left,
            title: Text("Child Accounts"),
          ),
        ]
            .map((e) => Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: e,
                ))
            .toList(),
      ),
    );
  }
}

class NewAccountForm extends StatefulWidget {
  NewAccountForm({required this.onSubmit});

  final void Function(AccountBuilder newAccount, Account? parent) onSubmit;

  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _account = AccountBuilder()
    ..startingBalance = 0
    ..parent = null;
  Account? _parentAccount;

  void _saveParentAccount(Account? a) {
    setState(() {
      if (a != null) {
        _account.parent = a.id;
        _account.type = a.type;
      } else {
        _account.parent = null;
      }
    });
  }

  void _submitAccount(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_parentAccount != null && _parentAccount!.type != _account.type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "This account must be the same type as the specified parent account."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      widget.onSubmit(_account, _parentAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Modal(
      onSubmit: () => _submitAccount(context),
      acceptButtonText: "Create Account",
      title: "Create a new account",
      body: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AccountPropertyField(
                name: "Account Name",
                errorMessage: "Account name is required",
                onChanged: (String? value) =>
                    setState(() => _account.name = value!),
              ),
              AccountPropertyField(
                name: "Account Memo",
                required: false,
                errorMessage: "",
                onChanged: (String? value) =>
                    setState(() => _account.memo = value),
              ),
              CurrencyField(
                errorMessage: '',
                required: false,
                label: 'Starting Balance',
                onChanged: (double amount) =>
                    setState(() => _account.startingBalance = amount),
              ),
              AccountDropdownField(
                label: "Parent Account",
                onChanged: _saveParentAccount,
                errorMessage: "",
                required: false,
              ),
              DropdownButtonFormField<AccountType>(
                onChanged: (AccountType? type) =>
                    setState(() => _account.type = type),
                value: _account.type,
                validator: (t) =>
                    t == null ? "You must specify an account type" : null,
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
                    .map<DropdownMenuItem<AccountType>>((e) => DropdownMenuItem(
                        value: e, child: Text(e.toString().capitalize())))
                    .toList(),
              ),
              TagAdderField(
                filter: _account.type,
                onChanged: (List<AccountTag> tags) {
                  _account.tags = BuiltList<AccountTag>.from(tags).toBuilder();
                },
              ),
            ]
                .map<Widget>(
                    (e) => Padding(padding: EdgeInsets.all(10.0), child: e))
                .toList()),
      ),
    );
  }
}

class AccountPropertyField extends StandardFormField {
  AccountPropertyField(
      {required this.name,
      required this.errorMessage,
      this.validator,
      required Function(String?) onChanged,
      bool required = true})
      : super(required, onChanged);

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
      onChanged: this.onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: this.name,
        labelStyle: TextStyle(fontSize: 16.0),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
