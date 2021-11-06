import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:financier/src/models/timestamp.dart';

part 'report.g.dart';

abstract class Report implements Built<Report, ReportBuilder> {
  String get id;
  String? get previous;
  double get endBalance;
  BuiltTimestamp get start;
  BuiltTimestamp get end;
  String get account;

  BuiltList<Report> get composite;

  Report._();

  factory Report([updates(ReportBuilder b)]) = _$Report;
  static Serializer<Report> get serializer => _$reportSerializer;
}
