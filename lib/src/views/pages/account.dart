import 'package:financier/src/components/fields/account-dropdown.dart';
import 'package:financier/src/components/fields/currency.dart';
import 'package:financier/src/components/fields/standard-field.dart';
import 'package:financier/src/models/account.dart';
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
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          NewAccountForm(onSubmit: (n, p) => _saveAccount(n, p, context)),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  void _saveAccount(
      AccountBuilder newAccount, Account? parent, BuildContext ctx) async {
    try {
      Account child = await app.accounts.newAccount(newAccount);
      await app.accounts.addChildAccount(parent, child);
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
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: FocusableActionDetector(
            child: AccountList(_filteredType, key: _accountList),
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

  void _showAccountDetails(Account a) {
    showModalBottomSheet(
      context: context,
      builder: (c) =>
          AccountDetails(account: a, context: c, accountList: widget.key),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _errorContainer(String errorText) {
    return Container(
      child: Center(
        child: Text(errorText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: widget.type == null
          ? app.accounts.getAllAccounts()
          : app.accounts.getAccountsByType(widget.type!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorContainer(
              "Error loading accounts: " + snapshot.error.toString());
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.length <= 1) {
          return _errorContainer(
              "Could not find any accounts, try creating one");
        }
        List<Account> accounts = <Account>[
          for (var account in snapshot.data!)
            if (account.type != AccountType.none || account.parent != null)
              account
        ];
        return ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            return AccountListing(
              account: accounts[index],
              onTap: _showAccountDetails,
            );
          },
        );
      },
    );
  }
}

class AccountListing extends StatelessWidget {
  AccountListing({required this.account, required this.onTap});

  final Account account;
  final void Function(Account) onTap;

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
    String path = app.accounts.generateAccountPath(account);
    return Material(
      child: ListTile(
        onTap: () {
          this.onTap(this.account);
        },
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (path.length > 1)
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  path,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(account.name),
                _accountTypeBadgeGen(account.type)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AccountDetails extends StatelessWidget {
  AccountDetails(
      {required this.account,
      required this.context,
      required this.accountList});

  final Account account;
  final BuildContext context;
  final GlobalKey<_AccountListState> accountList;

  @override
  Widget build(BuildContext context) {
    String path = app.accounts.generateAccountPath(account);

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.account.name,
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        bool? confirm = await showDialog<bool>(
                          context: this.context,
                          builder: (ctx) => AlertDialog(
                              content: (account.children.length > 0)
                                  ? Text(
                                      "Are you sure you want to delete this account? This account has children, they will be made children to its parent account.")
                                  : Text(
                                      "Are you sure you want to delete this account?"),
                              actions: [
                                TextButton(
                                  child: Text("Yes",
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () => Navigator.pop(ctx, true),
                                ),
                                TextButton(
                                  child: Text("No",
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () => Navigator.pop(ctx, false),
                                )
                              ]),
                        );
                        if (confirm != null && confirm) {
                          await app.accounts.deleteAccount(account);
                          Navigator.pop(context);
                          accountList.currentState!.reload();
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text("Account type: " + account.type.toString().capitalize()),
          if (account.memo != null && account.memo!.length > 1)
            Text("Account memo: " + account.memo!),
          if (path.length > 1)
            Text("Account Parent: " + path)
          else
            Text("This account has no parent"),
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
      _parentAccount = a;
      if (a != null) _account.type = a.type;
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
                  DropdownButtonFormField(
                    onChanged: (AccountType? type) =>
                        setState(() => _account.type = type),
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
                        "Create Account",
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
