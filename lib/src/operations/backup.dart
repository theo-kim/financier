import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pincher/src/models/account.dart';
import 'package:pincher/src/models/timestamp.dart';
import 'package:pincher/src/models/transaction.dart';
import 'package:pincher/src/operations/master.dart';

typedef Backup = List<Map<String, String>>;

class BackupException implements Exception {
  BackupException(this.msg);

  final String msg;

  @override
  String toString() => msg;
}

class _SkipEntryException implements Exception {}

double moneyParse(String? money) {
  if (money == null) return 0.0;
  RegExp re = RegExp(r"([.\d,]+)");
  RegExpMatch? m = re.firstMatch(money);
  if (m == null) return 0;
  double? d = double.tryParse(money.substring(m.start, m.end));
  d ??= 0;

  return d;
}

Future<List<T>> restore<T>(
    Backup restoration, Future<bool?> Function(String) onWarn) async {
  if (T == Account) {
    return restoreAccounts(restoration, onWarn) as Future<List<T>>;
  } else if (T == Transaction) {
    return restoreTransactions(restoration, onWarn) as Future<List<T>>;
  } else {
    throw "Unknown entity type: " + T.toString();
  }
}

Future<List<Account>> restoreAccounts(
    Backup restoration, Future<bool?> Function(String) onWarn) async {
  return await syncBackupAccounts(restoration, onWarn);
}

Future<List<Transaction>> restoreTransactions(
    Backup restoration, Future<bool?> Function(String) onWarn) async {
  return await syncBackupTransactions(restoration, onWarn);
}

Backup parseBackupFile(FilePickerResult backup,
    {required Set<dynamic> requiredHeaders}) {
  List<Map<String, String>> restored = [];

  if (backup.files[0].size == 0 || backup.files[0].bytes == null)
    throw BackupException("The uploaded file is empty!");
  StringBuffer fileBuffer = StringBuffer();
  for (int byte in backup.files[0].bytes!) {
    fileBuffer.write(String.fromCharCode(byte));
  }

  List<List<dynamic>> csv = const CsvToListConverter(shouldParseNumbers: false)
      .convert(fileBuffer.toString());
  if (csv.length < 2)
    throw BackupException(
        "Your backup file is corrupted or does not contain any data check your file and try again.");
  List<dynamic> headers = csv[0];

  Set<dynamic> missingFields = requiredHeaders.difference(headers.toSet());
  Set<dynamic> extraFields = headers.toSet().difference(requiredHeaders);

  if (missingFields.length != 0)
    throw BackupException(
        "Your backup file does not contain all the required fields, missing: ${missingFields.join(", ")}");
  if (extraFields.length != 0)
    throw BackupException(
        "Your backup file contains extra fields, this is indicative of a corrupted backup: ${extraFields.join(", ")}");
  for (int i = 1; i < csv.length; ++i) {
    List<dynamic> row = csv[i];
    if (row.length != requiredHeaders.length)
      throw BackupException(
          "An entry in your backup file is incomplete, this is indicative of a corrupted file: ${row.toString()}");
    restored.add({});
    for (int col = 0; col < headers.length; ++col) {
      restored.last[headers[col]] = row[col] as String;
    }
  }

  return restored;
}

// Note to self, existing accounts with the same name will be overwritten
Future<List<Account>> syncBackupAccounts(List<Map<String, String>> backup,
    Future<bool?> Function(String) onWarn) async {
  List<Account> existing = await app.accounts.getAllAccounts();
  // gather account names to be added
  Set<String> newAccountNames = {};
  for (Map<String, String> a in backup) {
    newAccountNames.add(a["Account Name"]!);
  }
  // gather account names that already exist
  Set<String> existingAccountNames = {};
  for (Account a in existing) {
    existingAccountNames.add(a.name);
  }
  // check if there is a difference
  Set<String> overwrittenAccounts =
      newAccountNames.intersection(existingAccountNames);

  if (overwrittenAccounts.length > 0) {
    bool? proceed = await onWarn(
        "There are ${overwrittenAccounts.length} accounts that will be overwritten with this backup, proceed?");
    if (proceed == null || !proceed) {
      throw BackupException("Backup cancelled.");
    }
  }

  try {
    Map<String, String> referenceMap = {};
    Map<String, AccountBuilder> referenceCache = {};
    List<AccountBuilder> restoredAccounts = [];
    for (Account a in existing) referenceMap[a.name.toLowerCase()] = a.id;
    for (Map<String, String> a in backup)
      if (!overwrittenAccounts.contains(a["Account Name"]!))
        referenceMap[a["Account Name"]!.toLowerCase()] =
            a["Account Type"]!.toLowerCase() +
                "-" +
                a["Account Name"]!.replaceAll(" ", "_").toLowerCase();

    // update parents
    for (Map<String, String> row in backup) {
      String parentName = row["Parent Account"]!;
      if (parentName != "ROOT" &&
          referenceMap[parentName.toLowerCase()] == null) {
        throw BackupException(
            "Missing account in backup: " + row["Parent Account"]!);
      }
      String? parentRef;
      if (row["Parent Account"]!.toLowerCase() != "root")
        parentRef = referenceMap[row["Parent Account"]!.toLowerCase()];
      else
        parentRef = null;
      final AccountBuilder b = AccountBuilder()
        ..name = row["Account Name"]
        ..memo = row["Memo"]
        ..startingBalance = moneyParse(row["Starting Balance"])
        ..parent = parentRef
        ..type = AccountType.valueOf(row["Account Type"]!.toLowerCase());
      String selfRef =
          "${b.type!.toString()}-${b.name!.replaceAll(" ", "_").toLowerCase()}";
      restoredAccounts.add(b);
      referenceCache[selfRef] = restoredAccounts.last;
    }

    return await app.accounts.newAccountList(restoredAccounts, replace: true);
  } catch (e) {
    throw BackupException(
        "Cannot restore your backup, potentially a malformed file, error message: " +
            e.toString());
  }
}

Future<List<Transaction>> syncBackupTransactions(
    List<Map<String, String>> backup,
    Future<bool?> Function(String) onWarn) async {
  try {
    List<Account> accounts = await app.accounts.getAllAccounts();
    List<TransactionBuilder> transactionsFinal = [];
    Map<String, List<Map<String, String>>> transactions = {};
    for (Map<String, String> row in backup) {
      String currentID = row["Trans ID"]!;

      if (transactions.containsKey(currentID)) {
        transactions[currentID]!.add(row);
      } else {
        transactions[currentID] = [row];
      }
    }
    for (String id in transactions.keys) {
      try {
        List<TransactionSplit> splits = [];
        for (Map<String, String> s in transactions[id]!) {
          double amount = max(moneyParse(s["Credit"]), moneyParse(s["Debit"]));
          TransactionSplitType type = s["Credit"] == ""
              ? TransactionSplitType.debit
              : TransactionSplitType.credit;
          try {
            splits.add(TransactionSplit((b) => b
              ..account =
                  accounts.firstWhere((a) => a.name == s["Account Name"]).id
              ..amount = amount
              ..details = s["Details"]
              ..type = type));
          } on StateError {
            bool? proceed = await onWarn("Account " +
                s["Account Name"]! +
                " in transaction does not exist, proceed and skip transaction or cancel backup?");
            if (proceed == null || !proceed) {
              throw BackupException("Backup cancelled.");
            } else {
              throw _SkipEntryException();
            }
          }
        }
        final TransactionBuilder b = TransactionBuilder()
          ..date = (BuiltTimestampBuilder()
            ..date = DateTime.parse(transactions[id]![0]["Date"]!))
          ..payer = transactions[id]![0]["Payer/Payee"]
          ..type = TransactionType.transfer
          ..splits = BuiltList<TransactionSplit>.from(splits).toBuilder();
        transactionsFinal.add(b);
      } on _SkipEntryException {
        continue;
      }
    }

    return await app.transactions.newTransactionList(transactionsFinal);
  } on BackupException catch (e) {
    throw e;
  } catch (e) {
    throw BackupException(
        "Cannot restore your backup, potentially a malformed file, error message: " +
            e.toString());
  }
}
