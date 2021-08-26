import 'package:financier/src/components/appbar.dart';
import 'package:financier/src/components/dynamic-scaffold.dart';
import 'package:financier/src/components/fields/account-dropdown.dart';
import 'package:financier/src/components/fields/currency.dart';
import 'package:financier/src/components/fields/standard-field.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/components/navigation.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: DynamicScaffold(
        appBar: StanrdardAppBar(
            title: widget.title,
            bottom: TabBar(
              tabs: [
                Tab(
                    icon:
                        Text("Income", style: TextStyle(color: Colors.black))),
                Tab(
                    icon: Text("Expense"),
                    style: TextStyle(color: Colors.black)),
                Tab(icon: Text("Asset")),
                Tab(icon: Text("Liability")),
              ],
            )),
        drawer: NavigationDrawer(activePage: widget.title),
        body: TabBarView(children: [
          AccountList(AccountType.income),
          AccountList(AccountType.expense),
          AccountList(AccountType.asset),
          AccountList(AccountType.liability),
        ]),
        floatingActionButton: FloatingActionButton(
          tooltip: 'New Account',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    NewAccountForm(onSubmit: print),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AccountList extends StatefulWidget {
  AccountList(this.type);

  final AccountType type;

  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: AccountActions.manager.getAccountsByType(widget.type),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: Text("Could not load accounts"),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return AccountListing(account: snapshot.data![index]);
          },
        );
      },
    );
  }
}

class AccountListing extends StatelessWidget {
  AccountListing({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(account.name),
        ],
      ),
    );
  }
}

class NewAccountForm extends StatelessWidget {
  NewAccountForm({required this.onSubmit});

  final void Function(Account newAccount) onSubmit;

  final _formKey = GlobalKey<FormState>();
  final _account = AccountBuilder();

  void _saveParentAccount(Account? a) {
    if (a == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: AccountPropertyField(
                    name: "Account Name",
                    errorMessage: "Account name is required",
                    onSaved: (String? value) => _account.name = value!,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: AccountPropertyField(
                    name: "Account Memo",
                    required: false,
                    errorMessage: "",
                    onSaved: (String? value) => _account.memo = value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CurrencyField(
                    errorMessage: '',
                    required: false,
                    label: 'Starting Balance',
                    onSaved: (double amount) {
                      _account.startingBalance = amount;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: AccountDropdownField(
                    label: "Parent Account",
                    onSaved: _saveParentAccount,
                    errorMessage: "",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      onSubmit(_account.build());
                    }
                  },
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
  final bool Function(String value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (this.required &&
            value != null &&
            this.validator != null &&
            this.validator!(value)) {
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
