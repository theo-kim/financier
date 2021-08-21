import 'package:financier/src/models/account.dart';
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
}
