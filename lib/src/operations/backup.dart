import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/operations/accounts.dart';
import 'package:financier/src/operations/master.dart';

typedef Backup = List<Map<String, String>>;

class BackupException implements Exception {
  BackupException(this.msg);

  final String msg;

  @override
  String toString() => msg;
}

const Set<dynamic> _accountHeaders = {
  "Starting Balance",
  "Account Name",
  "Parent Account",
  "Account Type",
  "Memo",
};

double moneyParse(String? money) {
  if (money == null) return 0.0;
  RegExp re = RegExp(r"([.\d,]+)");
  RegExpMatch? m = re.firstMatch(money);
  if (m == null) return 0;
  double? d = double.tryParse(money.substring(m.start, m.end));
  d ??= 0;

  return d;
}

Future<List<Account>> restoreAccounts(
    FilePickerResult backup, Future<bool?> Function(String) onWarn) async {
  Backup restoration = restoreBackupFile(backup);

  return await syncBackupAccounts(restoration, onWarn);
}

Backup restoreBackupFile(FilePickerResult backup) {
  List<Map<String, String>> restored = [];

  if (backup.files[0].extension != "csv")
    throw BackupException("File must have the .csv extension");
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

  Set<dynamic> missingFields = _accountHeaders.difference(headers.toSet());
  Set<dynamic> extraFields = headers.toSet().difference(_accountHeaders);

  if (missingFields.length != 0)
    throw BackupException(
        "Your backup file does not contain all the required account fields, missing: ${missingFields.join(", ")}");
  if (extraFields.length != 0)
    throw BackupException(
        "Your backup file contains extra fields, this is indicative of a corrupted backup: ${extraFields.join(", ")}");
  for (int i = 1; i < csv.length; ++i) {
    List<dynamic> row = csv[i];
    if (row.length != 5)
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

  // take care of parent relations
  // This is a tricky problem, as parents are based on Database pointers,
  //    so to add parent - child relationships it must be in the db already

  // Two pass approach:
  //    pass one: create a map { Account Name: DocumentReference }
  //    pass two: update each account with its appropriate child / parent data
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
