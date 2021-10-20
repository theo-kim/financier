import 'package:financier/src/models/transaction.dart' as My;
import 'package:financier/src/operations/datasource.dart';

class TransactionActions {
  TransactionActions(this.data);

  DataSource data;

  List<My.Transaction>? _cache;

  Future<List<My.Transaction>> getAllTransactions() async {
    if (_cache != null) return _cache!;

    List<My.Transaction> transactions = await data.transactions.toList();

    _cache = transactions;
    return transactions;
  }

  String initTransaction() {
    return data.transactions.id();
  }

  Future<My.Transaction> newTransaction(
      My.TransactionBuilder transaction) async {
    transaction.id = initTransaction();

    My.Transaction t = transaction.build();

    data.transactions[t.id] = t;

    _cache!.add(t);
    return t;
  }
}
