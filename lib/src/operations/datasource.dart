import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/transaction.dart' as Built;
import 'package:financier/src/models/user.dart';
import 'package:financier/src/operations/converters.dart';

enum DataSourceType {
  Local,
  Remote,
}

class DataSourceException implements Exception {}

class DataSourceTypeMismatch extends DataSourceException {
  String toString() =>
      "You requested a data source by type, but the data source was configred to the other";
}

class DataConditionException extends DataSourceException {
  DataConditionException(this.msg);

  final String msg;

  @override
  String toString() => msg;
}

class Data<T> {
  Data(this.collection, this.type);

  final CollectionReference<T> collection;
  final DataSourceType type;

  Future<List<T>> toList() async {
    if (this.type == DataSourceType.Local)
      throw UnimplementedError();
    else {
      QuerySnapshot<T> snapshot = await collection.get();
      return snapshot.docs.map((e) => e.data()).toList();
    }
  }

  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  String id() => collection.doc().id;

  Future<T?> operator [](String id) async {
    if (this.type == DataSourceType.Local)
      throw UnimplementedError();
    else {
      DocumentSnapshot<T> snapshot = await collection.doc(id).get();
      return snapshot.data();
    }
  }

  void operator []=(String id, T value) async {
    if (this.type == DataSourceType.Local)
      throw UnimplementedError();
    else {
      await collection.doc(id).set(value);
    }
  }
}

class DataSource {
  DataSource({required this.type, required this.source, required this.user}) {
    accounts = Data<Account>(
        Converters.generic<Account>(
            remote.collection("userdata").doc(user.uid).collection("accounts")),
        type);
  }

  final DataSourceType type;
  final dynamic source;
  final BuiltUser user;

  late final Data<Account> accounts;
  late final Data<Built.Transaction> transactions;

  FirebaseFirestore get remote {
    if (this.type == DataSourceType.Local) throw DataSourceTypeMismatch();
    return source as FirebaseFirestore;
  }

  // Future<List<Account>> accounts(
  //     {List<AccountType>? accountType, List<AccountTag>? accountTag}) async {
  //   if (type == DataSourceType.Local)
  //     throw UnimplementedError();
  //   else {
  //     CollectionReference<Account> firestore = Converters.account(
  //         remote.collection("userdata").doc(user.uid).collection("accounts"));
  //     Query<Account> query = firestore;
  //     if (accountType != null) {
  //       if (accountType.length > 10)
  //         throw DataConditionException(
  //             "Where clauses can only have ten or fewer elements");
  //       query = query.where("type",
  //           whereIn:
  //               accountType.map((e) => serialize<AccountType>(e)).toList());
  //     }

  //     if (accountTag != null) {
  //       if (accountTag.length > 10)
  //         throw DataConditionException(
  //             "Where clauses can only have ten or fewer elements");
  //       query = query.where("tags",
  //           arrayContainsAny:
  //               accountTag.map((e) => serialize<AccountType>(e)).toList());
  //     }

  //     QuerySnapshot<Account> snapshot = await query.get();
  //     return snapshot.docs.map((e) => e.data()).toList();
  //   }
  // }

  // Future<void> addAccount(Account a) async {
  //   CollectionReference<Account> collection = Converters.account(
  //       remote.collection("userdata").doc(user.uid).collection("accounts"));
  //   String id =
  //       "${a.type.toString()}-${a.name.replaceAll(" ", "_").toLowerCase()}";
  //   DocumentReference<Account> ref = collection.doc(id);

  //   await ref.set(a);
  // }
}
