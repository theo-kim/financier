import 'package:built_value/built_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/entity.dart';
import 'package:financier/src/models/serializer.dart';
import 'package:financier/src/models/transaction.dart' as My;

final accountCollection =
    FirebaseFirestore.instance.collection("accounts").withConverter<Account>(
          fromFirestore: (snapshot, _) =>
              serializers.deserializeWith(Account.serializer, snapshot.data())!,
          toFirestore: (account, _) => serializers.serializeWith(
              Account.serializer, account) as Map<String, Object?>,
        );

final transactionCollection = FirebaseFirestore.instance
    .collection("transactions")
    .withConverter<My.Transaction>(
      fromFirestore: (snapshot, _) => serializers.deserializeWith(
          My.Transaction.serializer, snapshot.data())!,
      toFirestore: (transaction, _) => serializers.serializeWith(
          My.Transaction.serializer, transaction) as Map<String, Object?>,
    );
