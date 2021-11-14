import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/models/serializer.dart';
import 'package:pincher/src/models/transaction.dart' as Built;
import 'package:pincher/src/models/user.dart';

class Converters {
  static CollectionReference<T> generic<T>(
    CollectionReference collection,
  ) =>
      collection.withConverter<T>(
        fromFirestore: (snapshot, _) => serializers.deserializeWith(
            serializers.serializerForType(T) as Serializer<T>,
            snapshot.data())!,
        toFirestore: (object, _) => serializers.serializeWith(
                serializers.serializerForType(T) as Serializer<T>, object)
            as Map<String, Object?>,
      );

  static CollectionReference<BuiltUser> user() =>
      generic<BuiltUser>(FirebaseFirestore.instance.collection("userdata"));

  static CollectionReference<Account> account(CollectionReference collection) =>
      generic<Account>(collection);

  static CollectionReference<Built.Transaction> transaction(
          CollectionReference collection) =>
      generic<Built.Transaction>(collection);
}
