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
}
