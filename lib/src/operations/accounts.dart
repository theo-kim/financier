import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/models/report.dart';
import 'package:pincher/src/operations/datasource.dart';

Account unknownAccount = Account((b) => b
  ..parent = null
  ..type = AccountType.none
  ..name = "Unknown Account"
  ..memo = "This account has since been deleted"
  ..startingBalance = 0);

extension ListExtension on List<Account> {
  void replace(Account oldAccount, Account newAccount) {
    int index = this.indexOf(oldAccount);
    this.insert(index, newAccount);
    this.removeAt(index + 1);
  }
}

class AccountActions {
  AccountActions(this.data);

  final DataSource data;
  List<Account>? _cache;

  Future<List<Account>> getAllAccounts() async {
    if (_cache != null)
      return _cache!;
    else
      _cache = [];

    List<Account> accounts = await data.accounts.toList();

    _cache = _cache!.toSet().union(accounts.toSet()).toList();
    return accounts;
  }

  List<Account> getAllCachedAccounts() {
    if (_cache == null) throw "No cached accounts";
    return _cache!;
  }

  Future<List<Account>> getAllRootAccounts() async {
    if (_cache == null) await getAllAccounts();

    return _cache!.where((a) => a.parent == null).toList();
  }

  Future<List<Account>> getAccountsByParent(Account parent) async {
    if (_cache == null) await getAllAccounts();

    return _cache!.where((a) => a.parent == parent.id).toList();
  }

  Future<List<Account>> getAccountsByType(AccountType type) async {
    final result = <Account>[];

    if (_cache == null) {
      await getAllAccounts();
    }

    for (Account a in _cache!) {
      if (a.type == type) {
        result.add(a);
      }
    }

    return result;
  }

  Future<Account> newAccount(AccountBuilder account) async {
    Account a = account.build();
    data.accounts[a.id] = a;
    _cache!.add(a);
    return a;
  }

  Future<Account> alterAccount(AccountBuilder account) async {
    try {
      Account a = account.build();
      Account old = _cache!.firstWhere((ac) => ac.id == a.id);
      _cache!.replace(old, a);
      return a;
    } on StateError {
      throw "This account does not exist and cannot be altered";
    }
  }

  Future<List<Account>> newAccountList(List<AccountBuilder> account,
      {bool replace = false}) async {
    if (replace && _cache != null) _cache!.clear();
    List<Account> output = [];
    for (AccountBuilder a in account) {
      output.add(await newAccount(a));
    }

    return output;
  }

  Account getCachedAccount(Account a) {
    if (_cache == null) throw "Cache uninitialized";
    return _cache!
        .firstWhere((element) => element == a, orElse: () => unknownAccount);
  }

  Account getCachedAccountByReference(String ref) {
    if (_cache == null) throw Exception("Cache uninitialized");
    Account found = _cache!.firstWhere((element) => element.id == ref,
        orElse: () => unknownAccount);
    return found;
  }

  int computeAccountChildren(Account a) {
    if (_cache == null) throw Exception("Cache uninitialized");
    if (!_cache!.contains(a)) throw Exception("Account does not exist");
    int total = 0;
    for (Account _a in _cache!) {
      if (_a.parent == a.id) total++;
    }
    return total;
  }

  String generateAccountPath(Account a) {
    if (a.type == AccountType.none)
      throw "Cannot generate path for nonexistent account";
    if (_cache!.contains(a) == false)
      throw "Cannot perform operations for Accounts not yet stored";
    if (a.parent == null) return "/";
    List<String> buff = <String>[];
    for (Account? csr = getCachedAccountByReference(a.parent!);
        csr != null;
        csr = getCachedAccountByReference(csr.parent!)) {
      buff.insert(0, csr.name);
      if (csr.parent == null) break;
    }
    return buff.join("/") + "/";
  }

  Future<void> deleteAccount(Account a) async {
    if (_cache == null) await getAllAccounts();
    if (_cache!.contains(a) == false)
      throw "Cannot delete account that does not exist";
    if (a.type == AccountType.none) throw "Cannot delete an abstract account";
    // Don't need this cause no children reference
    // Remove this account from its parent's children
    // Find all the children of the parent
    for (int i = 0; i < _cache!.length; ++i) {
      Account child = _cache![i];
      // if you find a child with the correct parent
      if (child.parent == a.id) {
        // replace child parent with the deleted account's parent
        //    in cache
        _cache![i] = child.rebuild((b) => b..parent = a.parent);
        //    in cloud
        data.accounts[_cache![i].id] = _cache![i];
      }
    }

    // Remove deleted account from cache
    _cache!.remove(a);
    // Remove from database
    await data.accounts.delete(a.id);
    List<Report>? reports = await data.reports.searchByAccount(a);
    if (reports != null)
      for (Report r in reports) await data.reports.delete(r.id);
  }
}
