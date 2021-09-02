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

  Future<DocumentReference> newAccount(AccountBuilder account) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("accounts").doc();
    account.id = BuiltDocumentReference((b) => b..reference = ref).toBuilder();
    ref
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(account.build());
    _cache!.add(account.build());
    return ref;
  }

  Future<DocumentReference> addChildAccount(
      AccountBuilder parent, DocumentReference child) async {
    parent.children.add(BuiltDocumentReference((b) => b..reference = child));
    parent.id.reference!
        .withConverter(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              Account.serializer, transaction) as Map<String, Object?>,
        )
        .set(parent.build());
    for (Account a in _cache!) {
      if (a.id.reference!.id == parent.id.reference!.id) {
        a.rebuild((b) {
          b.children.add(BuiltDocumentReference((b) => b..reference = child));
        });
      }
    }
    return child;
  }
}
