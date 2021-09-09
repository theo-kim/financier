import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/serializer.dart';
import 'package:financier/src/operations/collections.dart';

Account unknownAccount = Account((b) => b
  ..parent = null
  ..type = AccountType.none
  ..name = "Unknown Account"
  ..startingBalance = 0
  ..id = BuiltDocumentReferenceBuilder());

extension ListExtension on List<Account> {
  void replace(Account oldAccount, Account newAccount) {
    int index = this.indexOf(oldAccount);
    this.insert(index, newAccount);
    this.removeAt(index + 1);
  }
}

class AccountActions {
  static late AccountActions manager;

  List<Account>? _cache;

  Future<List<Account>> getAllAccounts() async {
    if (_cache != null) return _cache!;

    final firestore = accountCollection;

    List<Account> accounts = [];
    var snapshot = await await firestore.get();
    for (int i = 0; i < snapshot.docs.length; ++i) {
      accounts.add(snapshot.docs[i].data());
    }
    _cache = accounts;
    return accounts;
  }

  Future<Account> getRootAccount() async {
    if (_cache == null) {
      await getAllAccounts();
    }

    for (Account a in _cache!) {
      if (a.type == AccountType.none) {
        return a;
      }
    }

    throw Exception("No root account?");
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
    DocumentReference ref =
        FirebaseFirestore.instance.collection("accounts").doc();
    account.id = BuiltDocumentReference((b) => b..reference = ref).toBuilder();
    Account a = account.build();
    await ref
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(a);
    _cache!.add(a);
    return a;
  }

  Account getCachedAccount(Account a) {
    if (_cache == null) throw Exception("Cache uninitialized");
    return _cache!
        .firstWhere((element) => element == a, orElse: () => unknownAccount);
  }

  Account getCachedAccountByReference(DocumentReference ref) {
    if (_cache == null) throw Exception("Cache uninitialized");
    Account found = _cache!.firstWhere(
        (element) => element.id.reference!.id == ref.id,
        orElse: () => unknownAccount);
    return found;
  }

  Future<Account> addChildAccount(Account parent, Account child) async {
    // if cache isn't loaded, load it
    if (_cache == null) await getAllAccounts();
    // Child must exist in the database first
    if (child.id.reference == null)
      throw Exception("Trying to update a child which does not yet exist");
    // Get the parent from the cache and update it with the reference to the child
    Account aOld = getCachedAccount(parent);
    Account a = aOld.rebuild((b) {
      b.children.add(
          BuiltDocumentReference((b) => b..reference = child.id.reference));
    });
    // update firestore
    await a.id.reference!
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(a);
    _cache!.replace(aOld, a);
    // Get the child from the cache and update it with the reference to the child
    Account cOld = getCachedAccount(child);
    Account c = cOld.rebuild((b) {
      b.parent =
          BuiltDocumentReference((b) => b..reference = parent.id.reference)
              .toBuilder();
    });
    // update firestore
    await c.id.reference!
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(c);
    _cache!.replace(cOld, c);
    return child;
  }

  String generateAccountPath(Account a) {
    if (a.parent == null || a.type == AccountType.none)
      throw "Cannot generate path for ROOT account";
    if (a.id.reference == null)
      throw "Cannot perform operations for Accountsnot yet stored";
    List<String> buff = <String>[];
    Account csr = a;
    while ((csr = getCachedAccountByReference(csr.parent!.reference!)).type !=
        AccountType.none) {
      buff.insert(0, csr.name);
    }
    return buff.join("/") + "/";
  }

  Future<void> deleteAccount(Account a) async {
    if (_cache == null) await getAllAccounts();
    if (a.id.reference == null) throw "Cannot delete unreferenced account";
    if (a.type == AccountType.none) throw "Cannot delete root account";
    // Remove this account from its parent's children
    final Account pOld = getCachedAccountByReference(a.parent!.reference!);
    final Account p = pOld.rebuild((b) {
      b.children
          .remove(BuiltDocumentReference((b) => b..reference = a.id.reference));
    });
    // update firestore
    await p.id.reference!
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(p);
    _cache!.replace(pOld, p);
    try {
      getCachedAccount(p);
    } catch (e) {
      print(e);
    }
    // If there are children, make them orphans
    if (a.children.length > 0) {
      for (BuiltDocumentReference r in a.children) {
        await addChildAccount(p, getCachedAccountByReference(r.reference!));
      }
    }
    // Remove deleted account from cache
    _cache!.remove(a);
    // Remove from database
    await a.id.reference!.delete();
  }
}
