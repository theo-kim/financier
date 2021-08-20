import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/serializer.dart';
import 'package:financier/src/models/transaction.dart' as My;
import 'package:financier/src/operations/collections.dart';

class TransactionActions {
  static late final TransactionActions manager;

  List<My.Transaction>? _cache;

  Future<List<My.Transaction>> getAllAccounts() async {
    // TODO
    throw UnimplementedError();
  }

  Future<void> newTransaction(My.TransactionBuilder transaction) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("transactions").doc();
    transaction.id =
        BuiltDocumentReference((b) => b..reference = ref).toBuilder();
    ref
        .withConverter(
          fromFirestore: (snapshot, _) => serializers.deserializeWith(
              My.Transaction.serializer, snapshot.data())!,
          toFirestore: (transaction, _) => serializers.serializeWith(
              My.Transaction.serializer, transaction) as Map<String, Object?>,
        )
        .set(transaction.build());
  }
}
