import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/serializer.dart';
import 'package:financier/src/models/transaction.dart' as My;
import 'package:financier/src/operations/collections.dart';
import 'package:financier/src/operations/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionActions {
  static late TransactionActions manager;

  List<My.Transaction>? _cache;

  Future<List<My.Transaction>> getAllTransactions() async {
    if (FirebaseAuth.instance.currentUser == null) throw "Not logged in";
    if (_cache != null) return _cache!;

    final firestore = transactionCollection;

    List<My.Transaction> transactions = [];
    var snapshot = await await firestore
        .where("owner", isEqualTo: UserActions.manager.currentUser.uid)
        .get();
    for (int i = 0; i < snapshot.docs.length; ++i) {
      transactions.add(snapshot.docs[i].data());
    }
    _cache = transactions;
    return transactions;
  }

  Future<My.Transaction> newTransaction(
      My.TransactionBuilder transaction) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("transactions").doc();

    transaction.owner = UserActions.manager.currentUser.toBuilder();
    transaction.id =
        BuiltDocumentReference((b) => b..reference = ref).toBuilder();
    My.Transaction t = transaction.build();
    ref
        .withConverter(
          fromFirestore: (snapshot, _) => serializers.deserializeWith(
              My.Transaction.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              My.Transaction.serializer, transaction) as Map<String, Object?>,
        )
        .set(t);
    _cache!.add(t);
    return t;
  }
}
