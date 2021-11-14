import 'package:built_collection/built_collection.dart';
import 'package:pincher/src/components/fields/account-dropdown.dart';
import 'package:pincher/src/components/fields/currency.dart';
import 'package:pincher/src/components/fields/standard-field.dart';
import 'package:pincher/src/components/fields/tag-adder.dart';
import 'package:pincher/src/components/modal.dart';
import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/models/accounttags.dart';
import 'package:pincher/src/operations/master.dart';
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

  bool _isLoading = true;

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
    return Stack(
      children: <Widget>[
        FocusableActionDetector(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 67),
                child: AccountList(
                  type: _filteredType,
                  key: _accountList,
                  title: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Accounts",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 1000,
                    child: Material(
                      elevation: 6.0,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      color: Color(0xfff0f0f0),
                      child: Column(children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 57,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    "Accounts",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // if (_isLoading) LinearProgressIndicator(),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
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
    this.renderCard = true,
    this.indent = 0,
  });

  final AccountType? type;
  final Account? parent;
  final GlobalKey<_AccountListState> key;
  final String errorMsg;
  final String emptyMsg;
  final TextAlign msgAlignment;
  final Widget title;
  final bool renderCard;
  final double indent;

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
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: 1000,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: widget.renderCard ? 1 : 0,
              color: Color(0xfffafafa),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return AccountListing(
                        indent: widget.indent,
                        accountList: widget.key,
                        account: accounts[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }
}

class AccountListing extends StatelessWidget {
  AccountListing({
    required this.account,
    required this.accountList,
    required this.indent,
  });

  final Account account;
  final GlobalKey<_AccountListState> accountList;
  final double indent;

  Widget _accountTypeBadgeGen(AccountType t) {
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Chip(
        backgroundColor: backgroundColor,
        label: SizedBox(
          width: 50.0,
          child: Text(t.toString().capitalize(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _subdirIcon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 75.0,
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.subdirectory_arrow_right,
          ),
        ),
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
          leading: this.indent > 0
              ? _subdirIcon()
              : _accountTypeBadgeGen(account.type),
          title: Text(account.name),
          subtitle: (account.memo == null || account.memo!.length == 0)
              ? null
              : Text(account.memo!),
          backgroundColor: Color(0xfffafafa),
          children: [
            AccountDetails(
              indent: this.indent,
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
    required this.indent,
  });

  final Account account;
  final BuildContext context;
  final GlobalKey<_AccountListState> accountList;
  final double indent;

  final GlobalKey<_AccountListState> _childList =
      GlobalKey<_AccountListState>();

  void _editAccount() async {
    await showDialog(
      context: context,
      builder: (context) => NewAccountForm(
        disableUniqueFields: true,
        onSubmit: (newAccount, b) async {
          try {
            await app.accounts.alterAccount(newAccount);
            Navigator.of(context).pop();
            accountList.currentState!.reload();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error while edit account: " + e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        template: this.account,
      ),
    );
  }

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
        left: this.indent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(width: 115 - this.indent),
              TextButton(
                onPressed: _deleteAccount,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              TextButton(
                onPressed: _editAccount,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Edit Account",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ]
                .map<Widget>((e) => Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: e,
                    ))
                .toList(),
          ),
          AccountList(
            parent: account,
            key: _childList,
            renderCard: false,
            emptyMsg: "",
            msgAlignment: TextAlign.left,
            title: Text("Child Accounts"),
            indent: indent + 35,
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
  NewAccountForm(
      {required this.onSubmit,
      this.template,
      this.disableUniqueFields = false});

  final void Function(AccountBuilder newAccount, Account? parent) onSubmit;
  final Account? template;
  bool disableUniqueFields;

  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final _account;
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
  void initState() {
    if (widget.template != null) {
      _account = widget.template!.toBuilder();
    } else {
      _account = AccountBuilder()
        ..startingBalance = 0
        ..parent = null;
    }
    super.initState();
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
                value: _account.name,
                enabled: !widget.disableUniqueFields,
                name: "Account Name",
                errorMessage: "Account name is required",
                onChanged: (String? value) =>
                    setState(() => _account.name = value!),
              ),
              AccountPropertyField(
                value: _account.memo,
                name: "Account Memo",
                required: false,
                errorMessage: "",
                onChanged: (String? value) =>
                    setState(() => _account.memo = value),
              ),
              CurrencyField(
                value: _account.startingBalance,
                errorMessage: '',
                required: false,
                label: 'Starting Balance',
                onChanged: (double amount) =>
                    setState(() => _account.startingBalance = amount),
              ),
              AccountDropdownField(
                initialValue: _account.parent,
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
      this.value,
      this.enabled = true,
      required Function(String?) onChanged,
      bool required = true})
      : super(required, onChanged);

  final String name;
  final bool enabled;
  final String? value;
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
      initialValue: this.value,
      enabled: this.enabled,
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
