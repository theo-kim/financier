import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/report.dart';
import 'package:financier/src/models/timestamp.dart';
import 'package:financier/src/models/transaction.dart' as Built;
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/models/user.dart';
import 'package:financier/src/operations/converters.dart';
import 'package:tuple/tuple.dart';

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

class ReportData extends Data<Report> {
  ReportData(CollectionReference<Report> collection, DataSourceType type)
      : super(collection, type);

  Future<List<Report>?> searchByDate(Account a, DateTime t) async {
    if (this.type == DataSourceType.Local)
      throw UnimplementedError();
    else {
      QuerySnapshot<Report> snapshot = await collection
          .where("account", isEqualTo: a.id)
          .where("start", isLessThanOrEqualTo: t)
          .get();
      return snapshot.docs
          .map<Report>((q) => q.data())
          .toList()
          .where((r) => r.end.date.isAfter(t))
          .toList();
    }
  }

  Future<List<Report>?> searchByRange(Account a,
      {required DateTime start, required DateTime end}) async {
    if (this.type == DataSourceType.Local)
      throw UnimplementedError();
    else {
      QuerySnapshot<Report> snapshot = await collection
          .where("account", isEqualTo: a.id)
          .where("start", isGreaterThanOrEqualTo: start)
          .get();
      return snapshot.docs
          .map<Report>((q) => q.data())
          .toList()
          .where((r) => r.end.date.isBefore(end))
          .toList();
    }
  }

  Future<List<Report>?> searchByAccount(Account a) async {
    if (this.type == DataSourceType.Local)
      throw UnimplementedError();
    else {
      QuerySnapshot<Report> snapshot =
          await collection.where("account", isEqualTo: a.id).get();
      return snapshot.docs.map<Report>((q) => q.data()).toList();
    }
  }

  Future<Report?> mostRecent(String account, DateTime since) async {
    QuerySnapshot<Report> snapshot = await collection
        .where("account", isEqualTo: account)
        .where("end", isLessThan: Timestamp.fromDate(since))
        .orderBy("end", descending: true)
        .limit(1)
        .get();
    if (snapshot.size == 0)
      return null;
    else
      return snapshot.docs.first.data();
  }

  Future<Report> createFor(
      {required String account,
      required DateTime d,
      required double amount}) async {
    Report? previousReport =
        await mostRecent(account, DateTime(d.year, d.month, 1, 0, 0, 0));
    ReportBuilder rb = ReportBuilder()
      ..account = account
      ..endBalance = amount
      ..start = (BuiltTimestampBuilder()
        ..date = DateTime(d.year, d.month, 1, 0, 0, 0))
      ..end = (BuiltTimestampBuilder()
        ..date = DateTime(d.year, d.month + 1, 1, 0, 0, 0))
      ..previous = previousReport == null ? null : previousReport.id;
    rb.id = this.id();

    Report r = rb.build();
    collection.doc(rb.id).set(r);
    return r;
  }

  Future<int> update(Built.Transaction t) async {
    int reportsUpdated = 0;
    for (TransactionSplit split in t.splits) {
      QuerySnapshot<Report> query = await collection
          .where("account", isEqualTo: split.account)
          .where("start", isLessThanOrEqualTo: Timestamp.fromDate(t.date.date))
          .get();
      if (query.docs.length == 0 ||
          query.docs
              .where((q) => q.data().end.date.isAfter(t.date.date))
              .isEmpty) {
        // by default create a report for this month
        createFor(
            account: split.account,
            d: t.date.date,
            amount: split.amount *
                ((split.type == Built.TransactionSplitType.credit) ? -1 : 1));
      } else {
        // update the existing reports
        for (QueryDocumentSnapshot<Report> doc in query.docs) {
          Report r = doc.data();
          if (r.end.date.isAfter(t.date.date)) {
            doc.reference.set(r.rebuild((b) => b
              ..endBalance = (b.endBalance! +
                  split.amount *
                      ((split.type == Built.TransactionSplitType.credit)
                          ? -1
                          : 1))));
            reportsUpdated++;
          }
        }
      }
    }
    return reportsUpdated;
  }
}

class DataSource {
  DataSource({required this.type, required this.source, required this.user}) {
    accounts = Data<Account>(
        Converters.generic<Account>(
            remote.collection("userdata").doc(user.uid).collection("accounts")),
        type);
    transactions = Data<Built.Transaction>(
        Converters.generic<Built.Transaction>(remote
            .collection("userdata")
            .doc(user.uid)
            .collection("transactions")),
        type);
    reports = ReportData(
        Converters.generic(
            remote.collection("userdata").doc(user.uid).collection("reports")),
        type);
  }

  final DataSourceType type;
  final dynamic source;
  final BuiltUser user;

  late final Data<Account> accounts;
  late final Data<Built.Transaction> transactions;
  late final ReportData reports;

  FirebaseFirestore get remote {
    if (this.type == DataSourceType.Local) throw DataSourceTypeMismatch();
    return source as FirebaseFirestore;
  }
}
