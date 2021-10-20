import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financier/src/models/user.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/operations/converters.dart';
import 'package:financier/src/operations/datasource.dart';
import 'package:financier/src/operations/transactions.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum OperationsMode {
  Cloud,
  Local,
}

class UnauthenticatedError implements Exception {
  @override
  String toString() => "You are not logged in!";
}

class NonexistantRecordError implements Exception {
  @override
  String toString() => "The requested record is non-existant";
}

class _MasterOperations {
  _MasterOperations(this.mode, {required this.db, this.auth});

  _MasterOperations.cloud()
      : mode = OperationsMode.Cloud,
        auth = FirebaseAuth.instance;

  _MasterOperations.local()
      : mode = OperationsMode.Local,
        auth = null; // todo convert to a local JSON file

  final OperationsMode mode;
  late final DataSource db;
  final FirebaseAuth? auth;

  late final BuiltUser currentUser;

  late final AccountActions accounts;
  late final TransactionActions transactions;

  Future<void> initialize() async {
    if (mode == OperationsMode.Cloud) {
      currentUser = await getUserCloud();
      db = DataSource(
          type: DataSourceType.Remote,
          source: FirebaseFirestore.instance,
          user: currentUser);
      accounts = AccountActions(db);
      transactions = TransactionActions(db);
    } else {
      throw UnimplementedError();
    }
  }

  Future<BuiltUser> getUserCloud() async {
    if (auth!.currentUser == null) throw UnauthenticatedError();
    DocumentReference<BuiltUser> ref =
        Converters.user().doc(auth!.currentUser!.uid);
    DocumentSnapshot<BuiltUser> snapshot = await ref.get();
    if (snapshot.data() == null) throw NonexistantRecordError();
    return snapshot.data()!;
  }

  BuiltUser getUserLocal() {
    // TODO: implement local storage
    throw UnimplementedError("");
  }
}

_MasterOperations app = _MasterOperations.cloud();
