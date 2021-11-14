import 'package:pincher/src/models/transaction.dart';
import 'package:pincher/src/operations/datasource.dart';

class TransactionActions {
  TransactionActions(this.data);

  DataSource data;

  List<Transaction>? _cache;

  Future<List<Transaction>> getAllTransactions(
      {int start = 0, int number = 10}) async {
    if (_cache != null) return _cache!;

    List<Transaction> transactions = await data.transactions.toList();

    _cache = transactions;
    return transactions;
  }

  String initTransaction() {
    return data.transactions.id();
  }

  Future<Transaction> newTransaction(TransactionBuilder transaction) async {
    transaction.id = initTransaction();

    Transaction t = transaction.build();

    data.transactions[t.id] = t;

    _cache!.add(t);

    data.reports.update(t);

    return t;
  }

  Future<List<Transaction>> newTransactionList(
      List<TransactionBuilder> transactions) async {
    List<Transaction> output = [];
    for (TransactionBuilder b in transactions) {
      output.add(await newTransaction(b));
    }

    return output;
  }
}
