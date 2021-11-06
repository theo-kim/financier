import 'package:financier/src/models/report.dart';
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/operations/datasource.dart';

class ReportingActions {
  ReportingActions(this.data);

  DataSource data;

  List<Report>? _cache;

  Future<int> updateReports(Transaction t) async {
    return data.reports.update(t);
  }
}
