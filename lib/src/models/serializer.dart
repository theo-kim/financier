import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/accounttags.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/report.dart';
import 'package:financier/src/models/timestamp.dart';
import 'package:financier/src/models/transaction.dart';
import 'package:financier/src/models/user.dart';

part 'serializer.g.dart';

@SerializersFor(const [BuiltDocumentReference])
final Serializers referenceSerializers = _$referenceSerializers;

@SerializersFor(const [BuiltTimestamp])
final Serializers builtTimestampSerializers = _$builtTimestampSerializers;

@SerializersFor(const [
  Account,
  AccountType,
  AccountTag,
  BuiltUser,
  Transaction,
  TransactionSplit,
  TransactionSplitType,
  Report,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

Object serialize<T>(dynamic value) => standardSerializers.serializeWith<T>(
    standardSerializers.serializerForType(T) as Serializer<T>, value)!;

T deserialize<T>(dynamic value) => standardSerializers.deserializeWith<T>(
    standardSerializers.serializerForType(T) as Serializer<T>, value)!;

BuiltList<T> deserializeListOf<T>(dynamic value) => BuiltList.from(
    value.map((value) => deserialize<T>(value)).toList(growable: false));

List<Object> serializeListOf<T>(BuiltList<T> value) =>
    value.map((value) => serialize<T>(value)).toList(growable: false);
