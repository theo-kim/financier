import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/serializer.dart';
import 'package:financier/src/operations/collections.dart';

class AccountActions {
  static late final AccountActions manager;

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
    ref
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
    return _cache!.firstWhere((element) => element == a,
        orElse: () => throw Exception("parent account does not exist"));
  }

  Account getCachedAccountByReference(DocumentReference ref) {
    return _cache!.firstWhere((element) => element.id.reference!.id == ref.id,
        orElse: () =>
            throw Exception("account does not exist with that reference"));
  }

  Future<Account> addChildAccount(Account parent, Account child) async {
    // if cache isn't loaded, load it
    if (_cache == null) await getAllAccounts();
    // Child must exist in the database first
    if (child.id.reference == null)
      throw Exception("Trying to update a child which does not yet exist");
    // Get the parent from the cache and update it with the reference to the child
    final Account a = getCachedAccount(parent).rebuild((b) {
      b.children.add(
          BuiltDocumentReference((b) => b..reference = child.id.reference));
    });
    // update firestore
    a.id.reference!
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(a);
    // Get the child from the cache and update it with the reference to the child
    final Account c = getCachedAccount(child).rebuild((b) {
      b.parent =
          BuiltDocumentReference((b) => b..reference = parent.id.reference)
              .toBuilder();
    });
    // update firestore
    c.id.reference!
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(c);
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
}
