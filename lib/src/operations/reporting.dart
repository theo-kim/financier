import 'package:pincher/src/models/report.dart';
import 'package:pincher/src/models/transaction.dart';
import 'package:pincher/src/operations/datasource.dart';

class ReportingActions {
  ReportingActions(this.data);

  DataSource data;

  List<Report>? _cache;

  Future<int> updateReports(Transaction t) async {
    return data.reports.update(t);
  }
}
