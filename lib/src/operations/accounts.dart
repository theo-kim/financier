import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/serializer.dart';
import 'package:financier/src/operations/converters.dart';
import 'package:financier/src/operations/datasource.dart';
import 'package:financier/src/operations/master.dart';
import 'package:financier/src/operations/users.dart';

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
    return a;
  }

  Future<List<Account>> newAccountList(List<AccountBuilder> account) async {
    List<Account> output = [];
    for (AccountBuilder a in account) {
      output.add(await newAccount(a));
    }

    return output;
  }

  Account getCachedAccount(Account a) {
    if (_cache == null) throw Exception("Cache uninitialized");
    return _cache!
        .firstWhere((element) => element == a, orElse: () => unknownAccount);
  }

  Account getCachedAccountByReference(String ref) {
    if (_cache == null) throw Exception("Cache uninitialized");
    Account found = _cache!.firstWhere((element) => element.name == ref,
        orElse: () => unknownAccount);
    return found;
  }

  Future<Account> addChildAccount(Account? parent, Account child) async {
    // if cache isn't loaded, load it
    if (_cache == null) await getAllAccounts();
    // Child must exist in the database first
    if (_cache!.contains(child) == false)
      throw Exception("Trying to update a child which does not yet exist");
    String? parentId;
    if (parent != null) {
      // Parent must exist in the database first
      if (_cache!.contains(parent) == false)
        throw Exception("Trying to update a parent which does not yet exist");
      // Get the parent from the cache and update it with the reference to the child
      Account p = parent.rebuild((b) => b.children.add(child.id));
      // update firestore and the cache
      data.accounts[p.id] = p;
      _cache!.replace(parent, p);
      parentId = p.id;
    }
    // Get the child from the cache and update it with the reference to the child
    Account c = child.rebuild((b) => b..parent = parentId);
    // update firestore
    data.accounts[c.id] = c;
    _cache!.replace(child, c);
    return child;
  }

  String generateAccountPath(Account a) {
    if (a.parent == null || a.type == AccountType.none)
      throw "Cannot generate path for nonexistent account";
    if (_cache!.contains(a) == false)
      throw "Cannot perform operations for Accounts not yet stored";
    List<String> buff = <String>[];
    for (Account csr = a;
        csr.parent != null;
        csr = getCachedAccountByReference(csr.parent!)) {
      buff.insert(0, csr.name);
    }
    return buff.join("/") + "/";
  }

  Future<void> deleteAccount(Account a) async {
    if (_cache == null) await getAllAccounts();
    if (_cache!.contains(a) == false)
      throw "Cannot delete account that does not exist";
    if (a.type == AccountType.none) throw "Cannot delete an abstract account";
    // Remove this account from its parent's children
    if (a.parent != null) {
      // update firestore
      final Account pOld = getCachedAccountByReference(a.parent!);
      final Account p = pOld.rebuild((b) {
        b.children.remove(a.id);
      });
      data.accounts[p.name] = p;
      _cache!.replace(pOld, p);

      // If there are children, make them orphans
      if (a.children.length > 0) {
        for (String child in a.children) {
          await addChildAccount(p, getCachedAccountByReference(child));
        }
      }
    } else {
      // if this has no parent, just make the children have no parents and move on
      if (a.children.length > 0) {
        for (String child in a.children) {
          await addChildAccount(null, getCachedAccountByReference(child));
        }
      }
    }

    // Remove deleted account from cache
    _cache!.remove(a);
    // Remove from database
    await data.accounts.delete(a.id);
  }
}
